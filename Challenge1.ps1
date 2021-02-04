#Who wants to complete this? Oh I guess people chatted it real fast
Get-Service
| Where-Object {[String]$PSItem.Status -EQ 'Stopped'}
| Measure-Object
| ForEach-Object count