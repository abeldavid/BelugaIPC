require "spec_helper"

describe BelugaIPC::Manager do
  it "should be able to launch the server" do
    server = BelugaIPC::Manager.launch
    s = TCPSocket.new('127.0.0.1', 1234)
    s.gets
    s.puts "Ping"
    s.gets.should match "PONG"

    server.connections.should == 1

    s.puts "S"
    s.gets
    s.close

    BelugaIPC::Manager.join
  end

  it "should launch and wait for a shutdown" do
    BelugaIPC::Manager.launch :audit => true

    s = TCPSocket.new('127.0.0.1', 1234)
    s.gets
    s.puts("S")
    s.gets
    s.close

    BelugaIPC::Manager.join
  end
end