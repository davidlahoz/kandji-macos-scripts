# Kandji MacOS Scripts

## Overview

Welcome to the Kandji MacOS Scripts repository! This collection of scripts is designed to streamline various tasks for MacOS users, particularly those utilizing the Kandji platform. While some scripts in this repository are developed specifically for integration with Kandji — including generating alerts for Kandji's Admin panel and leveraging the Kandji CLI — others are more broadly applicable for routine monitoring and configuration tasks on MacOS.

The primary goal of these scripts is to automate repetitive tasks, simplify reporting, and assist in system configurations. They are crafted with practicality in mind and, although they might have room for optimization, they serve as reliable tools for everyday use.

### Features

- **Scripts Directory**: Contains essential monitoring scripts such as battery health status and FreeSpaceMonitor. These scripts utilize exit codes to communicate results effectively within the Kandji framework.

- **Utilities**: This section utilizes the Kandji API and Python to generate a list of installed applications in JSON format. It offers the flexibility to filter and create user lists based on application usage.

## Configuration

### Prerequisites

To utilize these scripts effectively, certain variables need to be set up as per your environment:

- `API_KEY`: Your personal API key from [Kandji](https://support.kandji.io/support/solutions/articles/72000560412-kandji-api).
- `subdomain`: Your specific Kandji subdomain.

## Acknowledgements

This project owes its thanks to:

- [Official Kandji Github Repository](https://github.com/kandji-inc/support) for their invaluable resources and tools.
- [Server Khalilov](https://github.com/red17electro) for the collaborative effort in resolving a particular sorting issue.
