Table of Contents

- [Overview](#-overview)

- [Features](#-features)

- [Screenshots-&-Demo](#-Screenshots-&-Demo)

- [Prerequisites](#-Prerequisites)

- [Infrastructure (Terraform)](#-Infrastructure (Terraform))


  
Overview

      This repository contains a structured learning roadmap covering Cloud Computing, Linux basics, 
      DevOps methodologies,AWS services, Docker, Infrastructure as Code (IaC), and certification preparation.

Features


	•	Introduction to cloud, Linux, and DevOps
	•	Hands-on AWS compute, storage, and database services
	•	Docker containerization and deployment
	•	Infrastructure as Code using Terraform or AWS CDK
	•	Complete project deployment cycle
	•	AWS certification preparation with practice exams

Screenshots & Demo

  <img width="1536" height="1024" alt="cloud" src="https://github.com/user-attachments/assets/9f65e14c-de04-4f53-b9ac-273c7d4ef0ee" />


Prerequisites

	•	Basic understanding of programming
	•	AWS account
	•	Git installed
	•	Python installed
	•	PostgreSQL installed
	•	Docker 


Infrastructure (Terraform)

  This project includes AWS infrastructure defined using Terraform:

  VPC
	  •	Custom VPC with CIDR block 10.0.0.0/16
	  •	Public and private subnets across multiple Availability Zones
	  •	Internet Gateway for public subnet
	  •	Public and private route tables

  EC2 Instance
	  •	EC2 instance in public subnet
	  •	Security group allowing SSH (22), HTTP (80), and app port (5000)
	  • Public IP association enabled

RDS (PostgreSQL)

    •	PostgreSQL RDS instance (engine version 17.4)
	  •	Multi-subnet DB subnet group for availability
	  •	Security group allowing traffic only from EC2 instance security group

S3 Bucket

	 •	S3 bucket for storing avatars: grocerymate-avatars-wasim2
	 •	Public access fully blocked for security
Table of Contents
	•	Overview￼
	•	Features￼
	•	Screenshots-&-Demo￼
	•	Prerequisites￼
	•	Infrastructure (Terraform)￼

Docker

Build & Push Docker Image

	•	Create a custom Dockerfile for the application
	
	•	Build the Docker image locally
	
	•	Push the image to your forked GitHub repository

docker build -t grocery-app .

Run Locally with Docker

	•	Run the container on your local machine
	
	•	Connect to PostgreSQL using host.docker.internal

docker run -p 5000:5000 \
  -e DB_HOST=host.docker.internal \
  grocery-app

Deploy Docker Container on EC2

	•	Install Docker on the EC2 instance
	
	•	Build or pull the Docker image
	
	•	Run the container on EC2

docker run -d -p 80:5000 grocery-app

 Usage
 
	 •	Access the application in  browser at: http://localhost:5000
	 •	Deploy to AWS using EC2, Docker, RDS, S3, and IaC tools as described in the course structure.

 
