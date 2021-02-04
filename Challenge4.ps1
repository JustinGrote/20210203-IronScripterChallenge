#List all loaded functions display name, number of parameter sets, and total function linesdir 

Get-ChildItem -Path Function: 
| Sort-Object Name
| Select-Object @(
    'Name'
    @{
        Name       = 'ParameterSetCount'
        Expression = {
            $_.parametersets.count
        }
    }
    @{
        Name       = 'Lines'
        Expression = {
            $_ScriptBlock
            | Measure-Object -Line
            | ForEach-Object Lines
        }
    }
)