function New-PUDDemoApiResponse {
    <#
        .SYNOPSIS
        Invokes a scriptblock and returns an object containing record count, status code, and the response as a
        PowerShellUniversal.ApiResponse object that will need to be returned by the API.

        .DESCRIPTION
        Invokes a scriptblock and returns an object containing record count, status code, and the response as a
        PowerShellUniversal.ApiResponse object that will need to be returned by the API.

        Possible status codes are:
            200 OK                    : Success
            204 No Content            : Success, no records found
            500 Internal Server Error : Internal server error

        .PARAMETER ScriptBlock
        The scriptblock to run to get the data that the API should return.

        .PARAMETER ReturnEmptyArrayOnNoResults
        Returns an empty array if no results are found.  Default behavior is to return nothing (null).

        .PARAMETER UseResponseBodyWrapper
        The API response body will be wrapped like so:
        {
            "success":      $Success
            "recordcount":  $RecordCount
            "data": {
                "objects" = $Result
            }
        }
        Where $Result is the response from SQL.
        If "UseResponseBodyWrapper" is not specified then the response will be simply $Result.

        .EXAMPLE
        $ScriptBlock = {
            Get-ADUser -Identity 'Frodo.Baggins' -Properties 'DisplayName' | Select-Object -Property 'DisplayName'
        }
        $NewPUDApiResponseParam = @{
            'ScriptBlock'            = $ScriptBlock
            'UseResponseBodyWrapper' = $false
            'ErrorAction'            = 'Stop'
        }
        $Response = $null
        $Response = New-PUDDemoApiResponse @NewPUDApiResponseParam
        $Response.Response

        Output of $Reponse is a PSCustomObject:
            RecordCount StatusCode Response
            ----------- ---------- --------
                1        200        PowerShellUniversal.ApiResponse

        Output of $Reponse.Reponse is a PowerShellUniversal.ApiResponse object:
            StatusCode  : 200
            Body        : {
                            "DisplayName": "Frodo Baggins"
                        }
            Cookies     : {}
            Data        : {}
            ContentType : application/json
            Headers     : {}
            File        :

        .NOTES
        ===========================================================================
        Created with: 	Visual Studio Code
        Created on:   	6/30/2023
        Created by:   	Sean.Sauve
        Organization: 	SAUSS
        Filename:       New-PUDDemoApiResponse.ps1
        ===========================================================================

        Modified:   Sean.Sauve
        Date:       7/3/2023
        Version:    1.1.0
        Comment:    Added ReturnEmptyArrayOnNoResults parameter.
                    Added 204 status code and ErrorMessage output on the ResponseBodyWrapper.
                    Added better handling for null results.

        Modified:   Sean.Sauve
        Date:       7/6/2023
        Version:    1.1.1
        Comment:    Moved 'data' to last element to maintain consistency with New-PUDDemoApiResponseSql.

        Modified:   Sean.Sauve
        Date:       9/6/2023
        Version:    1.2.0
        Comment:    Added application/problem+json response on error.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock,
        [switch]$ReturnEmptyArrayOnNoResults,
        [Alias('UseDecorator')]
        [switch]$UseResponseBodyWrapper
    )
    $StatusCode = 200
    $Success = $true
    $ContentType = 'application/json'
    try {
        $Result = $null
        $Result = . $ScriptBlock
        $RecordCount = @($Result).Count #Result must be wrapped in array in order to handle troublesome objects such as AD objects.
        if ($RecordCount -eq 0) {
            $StatusCode = 204
            $Success = $false
            if ($ReturnEmptyArrayOnNoResults) {
                $Result = @()
            }
        }
        if ($UseResponseBodyWrapper) {
            $Response = [PSCustomObject]@{
                'success'     = $Success
                'recordcount' = $RecordCount
                'data' = [PSCustomObject]@{
                    'objects' = $Result
                }
            }
        } else {
            $Response = $Result
        }
        $UseEmptyBody = $UseResponseBodyWrapper -eq $false -and $RecordCount -eq 0 -and $ReturnEmptyArrayOnNoResults -eq $false
        $BodyParam = $UseEmptyBody ? @{} : @{ 'Body' = ($Response | ConvertTo-Json -Depth 10) }
    } catch {
        Write-Warning "Error encountered: $_"
        $StatusCode = 500
        $Success = $false
        $Result = $null
        $RecordCount = 0
        $ContentType = 'application/problem+json'
        $Response = [PSCustomObject]@{
            'type' = 'https://mydomain.com/problems/unhandled-error'
            'title' = 'Internal Server Error'
            'status' = $StatusCode
            'detail' = $_.ToString()
            'instance' = ''
        }
        $BodyParam = @{ 'Body' = ($Response | ConvertTo-Json -Depth 10) }
    }
    [PSCustomObject]@{
        'RecordCount' = $RecordCount
        'StatusCode'  = $StatusCode
        'Response'    = New-PSUApiResponse -StatusCode $StatusCode @BodyParam -ContentType $ContentType
    }
}
