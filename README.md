# Intune For Experts

The **Intune For Experts Script** is a powerful tool designed to simplify the daily tasks of endpoint administrators. Created to optimize processes and tackle challenges in Microsoft Intune, this script is a true ally for professionals seeking efficiency and agility in their operations.  

Although it is still in the production phase, the script will remain in continuous development, receiving regular updates to meet the ever-changing needs of the market and IT administrators. Each update is crafted to provide practical and innovative solutions, making work more productive and precise.  

Our commitment is to create a tool that evolves alongside the demands of professionals, delivering indispensable support for those managing modern devices.  

Embrace **Intune For Experts** and follow the evolution of this initiative! 🚀


![image](https://github.com/user-attachments/assets/5ffc12da-5322-4ceb-b96e-fc2e6c144335)

## Connection Test (Application)

The **Connection Test (Application)** option is used to perform access tests to **Microsoft Graph** through an application registered in **Entra ID**. This functionality allows you to validate connections and ensure that the application is properly configured to securely and efficiently communicate with Microsoft services.

## Windows Autopilot (Application)

The **Windows Autopilot (Application)** option is used to enroll a device via **Autopilot**, using an application registered in **Entra ID**. This functionality allows you to automate and simplify the provisioning and configuration process of devices directly with the policies and settings defined in the organization.

## Windows Autopilot (Login)

The **Windows Autopilot (Login)** option is used to enroll a device via **Autopilot**, using login credentials and password. This functionality enables users to set up their devices quickly and in compliance with organizational policies, ensuring a simple and efficient experience.

## Create Win32 App

The **Create Win32 App** option is used to convert applications into the Win32 format. For this functionality to work correctly, the **IntuneWinAppUtil.exe** file must be located in a folder named **.\Microsoft-Win32-Content-Prep-Tool-master\**. This ensures that the packaging and preparation process for the application is properly executed for use in Microsoft Intune.

![image](https://github.com/user-attachments/assets/5ebde806-d203-4b0e-9d77-da4287ae8c19)


## Install Microsoft Graph for Intune

The **Install Microsoft Graph for Intune** option installs the **Microsoft Graph** module in PowerShell. This module is essential for the script to function properly, as it allows the script to communicate with Microsoft Graph services and perform operations in the Intune environment efficiently.

## List Sync Devices

The List Sync Devices option displays the date and time of the last synchronization of a device with Microsoft Intune, providing information on when the device was last synced with the platform to apply policies and configurations.

## Force Sync Devices

The **Force Sync Devices** option forces synchronization between **Intune** and the devices, making it very useful after configuring a policy. It ensures that the changes made are applied immediately to the devices, without having to wait for the standard sync cycle.

## All Devices NonCompliant

The **All Devices NonCompliant** option displays all devices that are not in compliance with the policies defined in **Microsoft Intune**. This allows administrators to quickly identify devices that do not meet the established security or configuration requirements.

## List Devices UserPrincipalName

The **List Devices UserPrincipalName** option lists all devices associated with the **UserPrincipalName** in **Microsoft Intune**. This allows administrators to quickly see which devices are linked to a specific user.

## List Serial Number

The **List Serial Number** option displays the serial number of a device through its **ID** in **Microsoft Intune**. This allows administrators to quickly and accurately identify the serial number associated with a specific device.

## List Device Clean UP - Days

A opção **List Device Clean UP - Days** lista a última sincronização de um dispositivo com base em uma quantidade de dias informada no terminal. Isso facilita a configuração do **Device Clean Up** no **Intune**, permitindo que os administradores gerenciem dispositivos que não foram sincronizados dentro do período especificado.

##  Disconnect Microsoft Graph

The **Disconnect Microsoft Graph** option disconnects from **Microsoft Graph**, ensuring a secure environment after the script has been used. This step is important to protect credentials and prevent unauthorized access to the service after the operations are completed.


