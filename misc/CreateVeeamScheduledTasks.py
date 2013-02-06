#!/usr/bin/env python
#
#

JOBS = [
("BDA", "DEV", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'BDA DEV'"),
("BDA", "TST", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'BDA TST'"),
("BDA", "LOD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'BDA LOD'"),
("BDA", "PPD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'BDA PPD'"),
("BDA", "PRD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bermuda -Vcenter vcenter101.vistaprint.net -vpenv prd -hostglob '*01' -job 'BDA PRD' -prod"),
("BHI", "DEV", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'BHI DEV'"),
("BHI", "TST", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'BHI TST'"),
("BHI", "LOD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'BHI LOD'"),
("BHI", "PPD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'BHI PPD'"),
("BHI", "PRD", "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Bhiwandi -Vcenter vcenter701.vistaprint.net -vpenv prd -hostglob '*01' -job 'BHI PRD' -prod"),
('DPK', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'DPK DEV'"),
('DPK', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'DPK TST'"),
('DPK', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'DPK LOD'"),
('DPK', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'DPK PPD'"),
('DPK', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter 'Deer Park' -Vcenter vcenter801.vistaprint.net -vpenv prd -hostglob '*01' -job 'DPK PRD' -prod"),
('VEN', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'VEN DEV'"),
('VEN', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'VEN TST'"),
('VEN', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'VEN LOD'"),
('VEN', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'VEN PPD'"),
('VEN', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Venlo -Vcenter vcenter301.vistaprint.net -vpenv prd -hostglob '*01' -job 'VEN PRD' -prod"),
('WND', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'WND DEV'"),
('WND', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'WND TST'"),
('WND', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'WND LOD'"),
('WND', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'WND PPD'"),
('WND', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Windsor -Vcenter vcenter101.vistaprint.net -vpenv prd -hostglob '*01' -job 'WND PRD' -prod"),
('LEX', 'DEV', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv dev -hostglob 'dev*01' -job 'LEX DEV'"),
('LEX', 'TST', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv tst -hostglob 'tst*01' -job 'LEX TST'"),
('LEX', 'LOD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv lod -hostglob 'lod*01' -job 'LEX LOD'"),
('LEX', 'PPD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv ppd -hostglob 'ppd*01' -job 'LEX PPD'"),
('LEX', 'PRD', "&amp;'C:\Program Files\Veeam\Add-VMsToVeeamBackupJob.ps1' -Datacenter Lexington -Vcenter vcenter101.vistaprint.net -vpenv prd -hostglob '*01' -job 'LEX PRD' -prod"),]

JOB_TMPL='''<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>2013-01-31T11:37:39.164985</Date>
    <Author>VISTAPRINTUS\\tmclaughlin</Author>
  </RegistrationInfo>
  <Triggers>
    <CalendarTrigger>
      <StartBoundary>2013-01-31T23:45:00</StartBoundary>
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
    f.write(JOB_TMPL % job[2])
    f.close()
    