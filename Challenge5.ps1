Get-Process -IncludeUserName
| Where-Object UserName
| Group-Object UserName
| Select-Object @(
    'Count'
    'Name'
    @{
        Name       = 'Processes'
        Expression = {
            $_.Group.Name
        }
    }
)