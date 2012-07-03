# Sample Powershell Script
# demonstrating retrieval of a Secret from Secret Server
# via web service protected by Windows Authentication 

$where = 'https://scrt.vistaprint.net/winauthwebservices/sswinauthwebservice.asmx'
$secretId = 639
$ws = New-WebServiceProxy -uri $where -UseDefaultCredential 
$wsResult = $ws.GetSecret($secretId)
if ($wsResult.Errors.length -gt 0){
	$wsResult.Errors[0]
}
else
{
	foreach ($item in $wsResult.Secret.Items)
	{ if ($item.FieldName -eq "Password") 
		{
			$item.Value
		}
	}
}