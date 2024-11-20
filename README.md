TuxCare Radar Installer Scripts
This repository contains three scripts to install and configure TuxCare Radar on RedHat-based and Debian-based Linux distributions. Each script provides a different way of handling the API key required for configuration, allowing flexibility based on your use case.

Scripts Overview
1. radar_installer.sh
This script is designed for mass usage by requiring the API key to be hard-coded into the script before execution. Ideal for environments where the same API key will be reused across multiple installations.

Usage:
Open the script in a text editor:

nano radar_installer.sh
Replace the your-api-key-here placeholder with your actual API key:


API_KEY="your-api-key-here"
Save the script and make it executable:


chmod +x radar_installer.sh
Run the script:


sudo ./radar_installer.sh



2. radar_installer2.sh
This script prompts the administrator for the API key during execution, making it suitable for one-off installations where the API key is not pre-configured in the script.

Usage:
Make the script executable:


chmod +x radar_installer2.sh
Run the script:


sudo ./radar_installer2.sh
When prompted, enter the API key:


Please enter your API key: <your-api-key>




3. radar_installer3.sh
This script accepts the API key as a command-line argument, allowing for seamless integration with automation tools or deployment pipelines.

Usage:
Make the script executable:


chmod +x radar_installer3.sh
Run the script, passing the API key as a parameter:


sudo ./radar_installer3.sh --apikey <your-api-key>
Example:


sudo ./radar_installer3.sh --apikey abc123xyz



Supported Operating Systems
RedHat-based distributions: RedHat, AlmaLinux, Oracle Linux, CentOS
Debian-based distributions: Debian, Ubuntu


Common Features
All scripts:

Detect the operating system and configure the correct TuxCare Radar repository.
Install the TuxCare Radar software.
Configure the software with the provided API key.
Validate the configuration file to ensure correctness.
Run tuxcare-radar as the nobody user to complete the setup.


Notes
Ensure the scripts are run with sudo or as the root user to avoid permission issues.
The API key is required for the software to function properly. Make sure you have a valid API key before running the scripts.
For mass deployments, consider using radar_installer.sh. For interactive or automated setups, use radar_installer2.sh or radar_installer3.sh.


License
This repository is licensed under the MIT License.

