
enet = require "enet"

base_port = 112344

moon = require "moon"

describe "enet", ->
  it "should gc host", ->
    do
      client = enet.host_create()
    collectgarbage!

  it "should gc destroyed host", ->
    do
      client = enet.host_create()
      client\destroy!
    collectgarbage!

  it "should host and client", ->
    host = enet.host_create "localhost:#{base_port}"
    assert.truthy host

    client = enet.host_create()
    client\connect "localhost:#{base_port}"

    local host_event, client_event
    while not client_event or not host_event
      client_event = client\service(10) or client_event
      host_event = host\service(10) or host_event

    assert.same "connect", host_event.type
    assert.same "connect", client_event.type

    host_event.peer\send "Hello World"

    host_event, client_event = nil

    while not client_event
      client_event = client\service(10) or client_event
      host_event = host\service(10) or host_event

    assert.same "receive", client_event.type
    assert.same "Hello World", client_event.data

  it "should error on destroyed host", ->
    client = enet.host_create()
    client\destroy!
    assert.has_error ->
      client\connect "localhost:7889"
