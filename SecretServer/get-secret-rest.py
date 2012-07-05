import argparse
import urllib
import xml.dom.minidom

DOMAIN = "VISTAPRINTUS"
URL = "https://scrt.vistaprint.net/webservices/sswebservice.asmx"

class SecretServer:
    AUTH_URL = "%s/Authenticate?username=%s&password=%s&domain=%s&organization=%s"
    GET_SECRET_URL = "%s/GetSecret?token=%s&secretId=%s"
    
    def __init__(self, url):
        self.url = url
        
    def authenticate(self, user, passwd, domain, org):
        '''
        Given a user, password, and domain authenticate and return a token
        string for use with other queries.
        '''
        # Make sure to convert from None to a string or it'll be
        # converted to "None" in the string expansion below.
        if not org:
            org = ''

        url = SecretServer.AUTH_URL % (self.url, user, passwd, domain, org)
        resp = urllib.urlopen(url)
        dom = xml.dom.minidom.parseString(resp.read())
        resp.close()
        token = dom.getElementsByTagName('Token')[0].firstChild.nodeValue
        return token

    def get_secret(self, token, ssid):
        '''
        Takes a token and secret server ID and returns a response object.
        '''
        url = SecretServer.GET_SECRET_URL % (self.url, token, ssid)
        resp = urllib.urlopen(url)
        dom = xml.dom.minidom.parseString(resp.read())
        resp.close()
        return dom
    
    def print_secret(self, secret):
        '''
        Parse and print then contents of the secret.
        '''
        name = secret.getElementsByTagName('Name')[0].firstChild.nodeValue
        id = secret.getElementsByTagName('Id')[0].firstChild.nodeValue
        print('\n\nName:\t\t%s\nId:\t\t%s' % (name, id))
        for item in secret.getElementsByTagName('SecretItem'):
            field = item.getElementsByTagName('FieldDisplayName')[0].firstChild.nodeValue
            if item.getElementsByTagName('Value')[0].childNodes:
                value = item.getElementsByTagName('Value')[0].firstChild.nodeValue
            else:
                value = None
            print('%s:\t%s' % (field, value))

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
    