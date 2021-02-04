
#The string is because of my bad mock
Get-Service 
| Where-Object {[String]$_.starttype -like 'Auto*'}
| Where-Object {[String]$_.status -ne 'Running'}
| Measure-Object
| ForEach-Object count

#Alternative pipeline format (PS5.1 Compatible)
# Get-Service |
#     Where-Object starttype -like 'Auto*' | 
#     Where-Object status -ne 'Running'| 
#     Measure-Object | 
#     ForEach-Object count