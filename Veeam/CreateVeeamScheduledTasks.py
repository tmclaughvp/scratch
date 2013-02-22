#!/usr/bin/env python
#
#

# ('DC', 'environment', 'cmd', 'time')
JOBS = [
    ("BDA", "DEV", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'BDA DEV'", '23:45:00'),
    ("BDA", "TST", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'BDA TST'", '23:45:00'),
    ("BDA", "LOD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'BDA LOD'", '23:45:00'),
    ("BDA", "PPD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'BDA PPD'", '23:45:00'),
    ("BDA", "PRD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv prd -hostglob '*01' -job 'BDA PRD' -prod", '23:45:00'),
    ("BHI", "DEV", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'BHI DEV'", '23:45:00'),
    ("BHI", "TST", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'BHI TST'", '23:46:00'),
    ("BHI", "LOD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'BHI LOD'", '23:47:00'),
    ("BHI", "PPD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'BHI PPD'", '23:48:00'),
    ("BHI", "PRD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv prd -hostglob '*01' -job 'BHI PRD' -prod", '23:49:00'),
    ('DPK', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'DPK DEV'", '23:45:00'),
    ('DPK', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'DPK TST'", '23:45:00'),
    ('DPK', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'DPK LOD'", '23:45:00'),
    ('DPK', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'DPK PPD'", '23:45:00'),
    ('DPK', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv prd -hostglob '*01' -job 'DPK PRD' -prod", '23:45:00'),
    ('VEN', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'VEN DEV'", '23:45:00'),
    ('VEN', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'VEN TST'", '23:45:00'),
    ('VEN', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'VEN LOD'", '23:45:00'),
    ('VEN', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'VEN PPD'", '23:45:00'),
    ('VEN', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv prd -hostglob '*01' -job 'VEN PRD' -prod", '23:45:00'),
    ('WND', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'WND DEV'", '23:49:00'),
    ('WND', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'WND TST'", '23:49:00'),
    ('WND', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'WND LOD'", '23:49:00'),
    ('WND', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'WND PPD'", '23:49:00'),
    ('WND', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv prd -hostglob '*01' -job 'WND PRD' -prod", '23:49:00'),
    ('LEX', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'LEX DEV'", '23:47:00'),
    ('LEX', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'LEX TST'", '23:47:00'),
    ('LEX', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'LEX LOD'", '23:47:00'),
    ('LEX', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'LEX PPD'", '23:47:00'),
    ('LEX', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv prd -hostglob '*01' -job 'LEX PRD' -prod", '23:47:00')
]

JOB_TMPL='''<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2013-01-31T11:37:39.164985</Date>
    <Author>VISTAPRINTUS\\tmclaughlin</Author>
  </RegistrationInfo>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>%sT%s</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>VISTAPRINTUS\\svc_veeam</UserId>
      <LogonType>Password</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>true</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>true</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>true</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT1H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>powershell</Command>
      <Arguments>%s</Arguments>
    </Exec>
  </Actions>
</Task>
'''

for job in JOBS:
    f = open('C:\\Users\\tmclaughlin\\Desktop\\VeeamTasks\\Veeam %s %s Add.xml' % (job[0], job[1]), 'w')
    f.write(JOB_TMPL % (time.strftime('%Y-%m-%d'), job[3], job[2]))
    f.close()
    
