*** Settings ***
Documentation    OneControlling RMI automation using Robot Framework
Resource    ../Pages/DefineScopePage.robot
Resource    ../Resources/JsonReader.robot
Resource    ../Pages/HomePage.robot
Resource    ../Pages/CommonFunctions.robot
Resource    ../Pages/SelectRawMaterial.robot
Resource    ../Pages/CalculateRMI.robot
Resource    ../Pages/Queries.robot
Test Teardown    End WebTest


*** Test Cases ***
STC_001_General planning end to end testing
    [Tags]    regression    retest    STC
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    general
    Add new line item    Mat Field
    Click on add button
    Edit the line item
    Delete the line item
    Add new line item    Mat Field
    Click on add button
    Click on save and next button to save line item
    Select raw materials and set matshare    Copper
    Click on save button to the save raw material
    Update matshare for existing raw material    30
    Click on next button
    Select first price model    Copper
    Click on save button to the save calculate rmi
    Click on Lock icon
    Click on Unlock icon
    Edit Base Price
    Click on save button to the save calculate rmi
    Neutralize the Fx effect
    De-Neutralize the Fx effect
    Get the aggregated value
    Click Back to raw material screen 
    Verify raw material page
    Update matshare for existing raw material    35
    Click on next button
    Validate the prices after changing mat share
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page
    Edit the line item
    Click on save and next button to save line item
    Click on next button
    Validate the prices after changing mat fields
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page
    Click on next button
    Click on next button
    Validate the prices should be same if no changes
    Back to my scope page
    Search container in search box
    Delete the container
    
STC_002_part number planning non steel end to end testing
    [Tags]    regression    retest    STC
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    partnumber
    Add new line items for part number planning    partnumber
    Click on save button to save the line item
    Edit the line item for part no planning
    Delete the line item
    Add new line items for part number planning    partnumber
    Click on save and next button to save line item
    Verify all the added masterdata for part no planning
    Select raw material and update prices for part no container    Copper
    Click Back to raw material screen 
    Deselect the raw material    Copper
    Select raw material and update prices for part no container     Aluminium
    Select first price model    Aluminium
    Click on save button to the save calculate rmi
    Click on Lock icon
    Click on Unlock icon
    Edit Base Price
    Click on save button to the save calculate rmi
    Neutralize the Fx effect
    De-Neutralize the Fx effect
    Get the aggregated value
    Expand or collapse the container    Aluminium
    Select second price model    Aluminium
    Click on save button to the save calculate rmi
    Expand or collapse the container    Aluminium
    Select manual price model with YTD and ROY split
    Click on save button to the save calculate rmi
    Validate the prices after changing mat share
    Click Back to raw material screen
    Deselect the raw material    Aluminium
    Select raw material and update prices for part no container    Copper
    Click Back to raw material screen 
    Edit raw material and operating weight for non steel raw material     Copper
    Select second price model    Copper
    Click on save button to the save calculate rmi
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page 
    Delete the line item
    Add new line items for part number planning    partnumber2
    Click on save and next button to save line item
    Click on next button
    Expand or collapse the container    Copper
    Validate the prices after changing mat fields
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page
    Click on next button
    Click on next button
    Validate the prices should be same if no changes
    Back to my scope page
    Search container in search box
    Delete the container

STC_003_Part Number Planning Steel end to end testing
    [Tags]    retest    STC
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    partnumber
    Add new line item for part number planning    partnumber
    Click on add button
    Click on save and next button to save line item
    Select multiselect raw material for part no planning  Steel
    Click on show edit link and validate the steel planning container
    Update the input weight and finished weight
    Click on save button to the save raw material
    Click on show edit link and validate the steel planning container
    Edit the input weight and finished weight
    Click on save and next button to save raw material
    Select first price model for steel part no planning    Steel
    Select manual price model for surcharge
    Click on Lock icon
    Click on Unlock icon
    Neutralize the Fx effect
    De-Neutralize the Fx effect
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page 
    Delete the line item
    Add new line items for part number planning    partnumber2
    Click on save and next button to save line item
    Click on next button
    Validate the prices after changing mat fields
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page
    Click on next button
    Click on next button
    Validate the prices should be same if no changes
    Back to my scope page
    Search container in search box
    Delete the container
 
STC_004_Export excel test cases for non-steel
    [Tags]    retest    STC
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    partnumber
    Add new line items for part number planning    partnumber
    Click on save button to save the line item
    Edit the line item for part no planning
    Delete the line item
    Add new line items for part number planning    partnumber
    Click on save and next button to save line item
    Verify all the added masterdata for part no planning
    Select raw material and update prices for part no container    Copper
    Click Back to raw material screen
    Export raw material report    sample
    Change the matshare and operating weight for non-steel and import
    Add junk values and validate the error message in excel    E14
    Click on next button
    Select first price model    Copper
    Click on save button to the save calculate rmi
    Click on Lock icon
    Click on Unlock icon
    Neutralize the Fx effect
    De-Neutralize the Fx effect
    Click Back to raw material screen
    Click on next button
    Click Back to raw material screen
    Deselect the raw material    Copper
    Select raw material and update prices for part no container    Aluminium
    Select first price model    Aluminium
    Click on save button to the save calculate rmi
    Click Back to raw material screen
    Export raw material report    sample1
    Change the matshare and operating weight for non-steel and import
    Add junk values and validate the error message in excel    E14 | E18    
    Click on next button
    Get the aggregated value
    Click Back to raw material screen
    Goto edit scope page
    Click on next button
    Click on next button
    Validate the prices should be same if no changes
    Back to my scope page
    Search container in search box
    Delete the container

STC_005_Export excel test cases for steel
    [Tags]    retest    STC    
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    partnumber
    Add new line items for part number planning    partnumber
    Click on save and next button to save line item
    Select multiselect raw material for part no planning  Steel
    Click on show edit link and validate the steel planning container
    Update the input weight and finished weight
    Click on save button to the save raw material    
    Export raw material report    rawMatReport    
    Change the matshare and operating weight for steel and import
    Add junk values and validate the error message in excel    E14
    Click on next button
    Select first price model for steel part no planning    Steel
    Select manual price model for surcharge
    Click on Lock icon
    Click on Unlock icon
    Neutralize the Fx effect
    De-Neutralize the Fx effect
    Click Back to raw material screen
    Back to my scope page
    Search container in search box
    Delete the container

STC_006_Export myscope page for non steel
    [Tags]    retest    STC
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    partnumber
    Add new line items for part number planning    partnumber
    Click on save and next button to save line item
    Select raw material and update prices for part no container    Copper
    Select first price model    Copper
    Click on save button to the save calculate rmi
    Get the aggregated value
    Export my scope page report for matfield    myscope
    Validate masterdata and rmi prices
    Back to my scope page
    Delete the container

STC_007_Validate RMI and volume report under myscope page
    [Tags]    retest
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    general
    Add new line item    Mat Field
    Click on add button
    Click on save and next button to save line item
    Select raw materials and set matshare    Copper
    Click on save button to the save raw material
    Click on next button
    Select first price model    Copper
    Click on save button to the save calculate rmi
    Click Back to raw material screen
    Select raw materials and set matshare    Aluminium
    Click on save and next button to save raw material
    Select first price model    Aluminium
    Click on save button to the save calculate rmi
    Back to my scope page
    Validate RMI and volume report under myscope page    rmiReport 
    Delete the container

STC_008_Validate download all myscope report
    [Tags]    retest
    Download my scope for all containers
 
STC_009_Verify the import base volume via excel
    [Tags]    retest
    Import base volume for matfields and validate in DB
    Download base volume excel and validate the headers
    Import base volume excel without masterdata and validate the error message

STC_010_Verify the import base volume from pnfc
    [Tags]    retest    
    Import base volume from PNFC

STC_011_Validate frozen activate and deactivate
    [Tags]    retest
    Validate frozen activate    true
    Validate frozen activate    false
    
STC_012_Validate the all and my scope toggle functionality
    [Tags]    retest
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    general
    Back to my scope page
    Validate the toggle functionalty
    Delete the container

STC_012_Validate price premises template
    [Tags]    retest
    Validate price premises template
        
STC_013_Validate the overlapping scope functionality
    [Tags]    retest
    Login to onecon rmi application
    Navigate to sub menu    Processes    PILUM - RMI
    Add new container and edit container name    general
    Add new line item    Mat Field
    Click on add button
    Click on save and next button to save line item
    Back to my scope page
    Add new container and edit container name    general2
    Add new line items for part number planning    partnumber
    Click on save and next button to save line item
    Back to my scope page
    Verify the overlapping scope
    
STC_014_import price premise report
    [Tags]    retest
    Verify import price premise functionality
    

