import argparse
from suds.client import Client

DOMAIN = "VISTAPRINTUS"
URL = "https://scrt.vistaprint.net/webservices/sswebservice.asmx"

class SecretServer:
	def __init__(self, url):
		self.url = url
		self.client = Client("%s?WSDL" % self.url)
		
	def authenticate(self, user, passwd, domain, org):
		'''
		Given a user, password, and domain authenticate and return a token
		string for use with other queries.
		'''
		resp = self.client.service.Authenticate(username=user,
												password=passwd,
												domain=domain,
										 		organization=org)
		if resp.Errors:
			raise Exception(resp.Errors.string[0])
		else:
			return resp.Token
	
	def get_secret(self, token, ssid):
		'''
		Takes a token and secret server ID and returns a response object.
		'''
		resp = self.client.service.GetSecret(token, ssid)
		return resp
	
	def print_secret(self, secret):
		print('Name:\t\t%s\nId:\t\t%s' % (secret.Secret.Name, secret.Secret.Id))
		for item in secret.Secret.Items.SecretItem:
			print('%s:\t%s' % (item.FieldDisplayName, item.Value))

if __name__ == '__main__':
	
	# Parse args
	parser = argparse.ArgumentParser(description='Query Secret Server for information.')
	parser.add_argument('-u', action='store', dest='user', default=None, required=True, help='User to login as')
	parser.add_argument('-p', action='store', dest='passwd', default=None, required=True, help='User\'s password')
	parser.add_argument('-d', action='store', dest='domain', default=DOMAIN, help='User\'s Domain')
	parser.add_argument('-o', action='store', dest='org', default=None, help='Secret Server organization')
	parser.add_argument('-s', action='store', dest='ssid', default=None, required=True, help='Secret Server ID to lookup')
	args = parser.parse_args()
	
	# Run
	r = SecretServer(URL)
	token = r.authenticate(args.user, args.passwd, args.domain, args.org)
	secret = r.get_secret(token, args.ssid)
	r.print_secret(secret)
	
	