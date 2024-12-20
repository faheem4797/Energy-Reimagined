# Energies Re-imagined  

A Flutter-based mobile application developed for a small-scale energy company to streamline operations between admins and technicians. This app supports job assignments, tool requests, and job completion tracking, making it an efficient solution for day-to-day operations.  

---

## Features  

### Admin Features  
- **User Management**: Create, edit, and manage users (Admins and Technicians).  
- **Job Management**: Create, assign, and edit jobs for technicians.  
- **Tool Management**: Manage tools inventory and fulfill tool requests.  

### Technician Features  
- **Job Handling**: Accept and complete assigned jobs by filling in proof of work.  
- **Tool Requests**: Request tools from the inventory. A QR code is generated for proof of tool delivery.  

---

## Technology Stack  

- **Framework**: Flutter  
- **State Management**: Bloc
- **Architecture**: Bloc Architecture
- **Backend**: Firebase

---

## Screenshots  

### Authentication Screens

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/d1bd1370-09f3-4b36-90d1-22662e02d1e6" width="32%" />
</p>


### Admin Users Section

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/12d5a9ed-f48d-490e-9c29-aef8a36ba16f" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/ff587a49-a15a-4a3d-a9bb-fbd8eb2a00ef" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/fbecbe5c-bbd5-4a15-997f-3406c97bde4f" width="32%" />
</p>

### Admin Tools Section

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/ba99158b-6c00-4bd7-b39f-de6e00cc864a" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/efe77579-63fe-465c-911b-1598e900774f" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/e50accb9-e91c-4f06-b269-8553fec680e3" width="32%" />
</p>

### Admin Jobs Section

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/6f326d75-a2ae-44f2-966a-eec83a2b471c" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/fb4de86d-96cc-410e-bb0c-78f2ba6b7e6b" width="32%" />
</p>

### Technician Jobs Section

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/81fd5904-f1eb-4f8d-8306-49e3927cc045" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/12fe0f27-edf4-4ad1-bd04-b5f2423c98fd" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/1b5754eb-1d74-410f-afb3-98fd7e8dea41" width="32%" />
</p>

### Tool Request Flow
## Technician Tools Request Section

The technician first needs to select the tools and choose their quantity and request them. This will send a request to admin side that a tool request has been made and a new QR code will be generated for this tool request.

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/aa9b617c-7184-48a5-a6d2-7109bbe8ad13" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/930378d1-3c8a-4b6d-a9c7-0c7cbe4ee1ea" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/547edda2-25d3-4a67-bbf4-2523c24d2c3e" width="32%" />
</p>

## Admin Tools Request Section

The admin will see the requested tools and will fetch them. To complete this tool request, the admin needs to scan the QR code being displayed on the technician's app.

<p align="middle" float="left">
  <img align="top" src="https://github.com/user-attachments/assets/9b36cd7c-a19d-491b-a34a-9ce98b2bcc90" width="32%" />
  <img align="top" src="https://github.com/user-attachments/assets/1aea9dca-df55-4bdc-aaf6-6c5a204217b8" width="32%" />
</p>


---

## Installation  

1. Clone the repository:  
   ```bash  
   git clone https://github.com/faheem4797/Energy-Reimagined.git  
   ```  

2. Navigate to the project directory:  
   ```bash  
   cd Energy-Reimagined
   ```  

3. Install dependencies:  
   ```bash  
   flutter pub get  
   ```  

4. Run the app:  
   ```bash  
   flutter run  
   ```  

---

## Usage  

- Admins can log in to manage users, tools, and jobs.  
- Technicians can log in to accept jobs, complete tasks, and request tools.  
- QR codes are generated and scanned for tool delivery verification.  


---

## License  

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.  

---

## Contact

For any queries or suggestions, please contact:

- **Name**: Muhammad Faheem Amin
- **Email**: mfaheemamin4797@gmail.com
- **GitHub**: [faheem4797](https://github.com/faheem4797)
