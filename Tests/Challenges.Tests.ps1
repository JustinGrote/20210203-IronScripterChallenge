Describe 'Challenges' {

    BeforeAll{
        $SCRIPTROOT = "$PSScriptRoot/.."
        $MOCKS = "$PSScriptRoot/Mocks"

        #Add a mock for get-service!
        #I took my Get-Service and exported it to clixml so I have a non-changing example.
        Mock -Verifiable Get-Service {Import-CliXML "$Mocks/Get-Service.clixml"}
    }

    Context 'Challenge1' {
        It 'Finds how many stopped services' {
            . $SCRIPTROOT/Challenge1.ps1 | Should -be 137
            Assert-VerifiableMock
        }
    }

    Context 'Challenge2' {
        #This is a bad test because it's dependent on my runtime. I should mock Get-Service
        #And get a predictable sample each time.
        It 'Automatic Start Services that are not running' {
            . $ScriptRoot/Challenge2.ps1 | Should -Be 6
        }
    }

    Context 'Challenge3' {
        #Mock: get-cimclass -classname win32_bios | Export-Clixml
        BeforeAll {
            Mock -Verifiable Get-CimClass {Import-Clixml "$Mocks/win32_bios.clixml"}
            $SCRIPT:Challenge3Result = . "$ScriptRoot/Challenge3.ps1"
        }
        It 'Gets the properties of win32_bios' {
            $Challenge3Result.count | Should -Be 35
        }

        It 'Has some of the properties we care about: <property>' {
            $Property | Should -BeIn $Challenge3Result
        } -TestCases @(
            @{'Property' = 'Name'}
            @{'Property' = 'ListOfLanguages'}
            @{'Property' = 'ReleaseDate'}
        )

        It 'Does not have property "notthere"' {
            'NotThere' | Should -Not -BeIn $Challenge3Result
        }
    }

    Context 'Challenge4' {
        BeforeAll {
            #Mock: Get-Childitem -Path function: | export-clixml
            Mock -Verifiable Get-ChildItem -ParameterFilter {$Path -eq 'function:'} {
                Import-Clixml "$Mocks/functions.clixml"
            }
            $SCRIPT:Challenge4Result = . "$ScriptRoot/Challenge4.ps1"
        }

        It 'Returns functions' {
            ($SCRIPT:Challenge4Result).foreach{
                $PSItem.psobject.properties.name.count | Should -Be 3
                'ParameterSetCount' | Should -Bein $PSItem.psobject.properties.name
            }
        }

        It 'Should return 141 functions' {
            $challenge4result.count | Should -be 141
        }
    }
}
