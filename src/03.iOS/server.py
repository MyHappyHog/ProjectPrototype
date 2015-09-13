from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

class IphoneChat(Protocol):
	def connectionMade(self):
		print "a client connected"
		                   
factory = Factory()
factory.protocol = IphoneChat
reactor.listenTCP(81, factory)
print "Iphone Chat server started"
reactor.run()
