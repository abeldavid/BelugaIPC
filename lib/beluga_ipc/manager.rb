module BelugaIPC
  # TODO: The port should be configurable
  class Manager
    def self.launch opts = Hash.new
      opts = {:port => 1234, :host => '127.0.0.1'}.merge(opts)
      @server = BelugaIPC::Server.new(opts[:port], opts[:host])
      @server.audit if opts[:audit]
      @server.start unless opts[:no_start]
      @server
    end

    def self.join
      @server.join unless @server.nil?
    end

    def self.launch_and_wait opts
      launch opts
      join
    end

    def self.start
      p = pid
      if pid > 0
        $stderr.puts "Beluga server already running on port 1234 with pid #{pid}"
      else
        pc? ? start_on_pc : start_on_posix
      end
    end

    def self.stop
      @server.stop unless @server.nil?
    end

    def self.restart
      kill
      start
    end

    def self.pid
      if pc?
        pid_on_pc
      else
        pid_on_posix
      end
    end

    def self.running?
      pid > 0
    end

    def self.kill
      p = pid
      return if p == 0
      s = TCPSocket.new('127.0.0.1', 1234)
      s.gets
      s.puts("S")
      s.close
      p = pid
      return if p == 0
      hard_kill(p)
    end

    private

    def self.pc?
      RUBY_PLATFORM.downcase =~ /mingw|mswin/
    end

    def self.pid_on_pc
      s = `netstat -anop TCP`.split("\n").find_all{|l| l =~ /:1234/ && l =~ /LISTENING/}.first
      s.nil? ? 0 : s.rpartition("\s").last.to_i
    end

    def self.pid_on_posix
      s = `lsof -i tcp:1234 | grep '(LISTEN)' | awk '{print $2}'`.strip
      s.nil? ? 0 : s.to_i
    end

    def self.hard_kill p
      pc? ? kill_on_pc(p) : kill_on_posix(p)
    end

    def self.kill_on_pc p = pid
      `taskkill /PID #{p}`
      raise "Could not kill IPC server" unless pid == 0
    end

    def self.kill_on_posix p = pid
      `kill #{p}`
      raise "Could not kill IPC server" unless pid == 0
    end

    def self.start_on_pc
      exec(%q{start "beluga_server" ruby -e "require 'beluga_ipc'; puts 'starting beluga server'; BelugaIPC::Manager.launch; puts 'running'; BelugaIPC::Manager.join; puts 'done'" >> "beluga_ipc.log" 2>&1})
    end

    def self.start_on_posix
      `ruby -e "require 'beluga_ipc'; BelugaIPC::Manager.launch; BelugaIPC::Manager.join" >> "beluga_ipc.log" 2>&1 &`
    end

  end
end
