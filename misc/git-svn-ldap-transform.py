#env python
#
# Parse an SVN authors file and query LDAP for information to create a
# transform file for git-svn.
#
# git-svn-ldap-transform.py -i <in_file> -o <out_file> -s <server> -u <user>

import argparse
import getpass
import ldap

REALM = 'VISTAPRINT.NET'
SERVER = 'ldap://ldap.vistaprint.net'
DC = 'dc=vistaprint,dc=net'
OU = 'ou=Vistaprint - Lexington,%s' % DC

def main (in_file, out_file, user, passwd, server, ou):
    pass

    # Open in file and get usernames
    in_file_obj = open(in_file, 'r')
    # file is in 'username = uasername <username>'
    user_list = []
    for l in in_file_obj.readlines():
        user_list.append(l.split('=')[0].strip())
    in_file_obj.close()
    
    # Necessary for TLS to work.  These options must be set globally.
    ldap.set_option(ldap.OPT_PROTOCOL_VERSION, ldap.VERSION3)
    ldap.set_option(ldap.OPT_X_TLS_DEMAND, True)
    ldap.set_option(ldap.OPT_X_TLS_REQUIRE_CERT, ldap.OPT_X_TLS_NEVER)
    
    l = ldap.initialize(server)
    l.start_tls_s()
    l.simple_bind_s(user, passwd)
    
    # append info in as 'username = name <email>'
    git_user_info_list = []
    for u in user_list:
        r = []
        try:
            r = l.search_s(OU, ldap.SCOPE_SUBTREE, '(samaccountname=%s)' % (u), 
                           ('displayName', 'userPrincipalName'))
        except ldap.FILTER_ERROR:
            print('Bad username: %s' % (u))
            
        if len(r) == 0:
            print("User not found: %s" % u)
            userinfo = '%s = %s <UNKNOWN>' % (u, u)
            git_user_info_list.append(userinfo)
        elif len(r) > 1:
            print("More than one found: %s (This should never happen...)" % u)
        else:
            userinfo = '%s = %s <%s>' % (u, r[0][1]['displayName'][0], r[0][1]['userPrincipalName'][0],)
            print(userinfo)
            git_user_info_list.append(userinfo)
    
    # Open outfile file for write
    out_file_obj = open(out_file, 'w')
    
    for u in git_user_info_list:
        out_file_obj.write('%s\n' % u)
    out_file_obj.close()
    
    print('~~~ Fin ~~~')

    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Read SVN authors and query LDAP to create transform file for Git..')
    parser.add_argument('-i', action='store', dest='in_file', default=None, required=True, help='File to read info from')
    parser.add_argument('-o', action='store', dest='out_file', default=None, required=True, help='File to write info to')
    parser.add_argument('-u', action='store', dest='user', default=None, required=True, help='User to query LDAP as.')
    args = parser.parse_args()
    
    passwd = getpass.getpass()
    
    ad_user = '%s@%s' % (args.user, REALM)
    
    main(args.in_file, args.out_file, ad_user, passwd, SERVER, OU)
        