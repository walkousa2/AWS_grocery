provider "aws" {
  region = "eu-north-1"
}
resource "aws_vpc" "my_vpc" {
      cidr_block = "10.0.0.0/16"
      tags = {
          Name = "terraform-EC2-to-RDS-VPC"
      }
}
resource "aws_internet_gateway" "ig_2tier" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
      Name = "terraform-Internet Gateway for EC2-to-RDS VPC"
    }
}
resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.my_vpc.id
    availability_zone = "eu-north-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
      Name = "Public Subnet"
    }
}
# PUBLIC ROUTE TABLE
  # Create a Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
      cidr_block = "0.0.0.0/0"  # This is the default route for internet-bound
      gateway_id = aws_internet_gateway.ig_2tier.id
    }
    tags = {
      Name = "public-route-table"
    }
}

  # PUBLIC
  # Associate Public Subnets with Route Table
resource "aws_route_table_association" "public-route-table-association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

    # Security Group for EC2
resource "aws_security_group" "wasim-ec2-sg" {
  name        = "wasim-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.my_vpc.id
  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }
  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }
  # Grocery mate app port
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Grocery mate application port"
  }
  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  tags = {
    Name    = "wasim-teraform-ec2-sg"
  }
}
resource "aws_iam_role" "grocery_ec2_role" {
  name = "wasim-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "terraform-wasim-ec2-role"
  }
}
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.grocery_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "terraform-iam-instance-ec2-profile"
  role = aws_iam_role.grocery_ec2_role.name

  tags = {
    Name    = "terraform-iam-instance-ec2-profile"
  }
}
# PUBLIC create EC2 instance
resource "aws_instance" "ec2" {
      ami = "ami-0c7d68785ec07306c"
      instance_type = "t3.micro"
      subnet_id = aws_subnet.public_subnet.id
      vpc_security_group_ids = [aws_security_group.wasim-ec2-sg.id]
      associate_public_ip_address = true
      iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
      tags = {
          Name = "EC2-for-RDS"
      }

}

##Private
  # Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
  tags = {
    Name = "Private Subnet-1"
  }
}
  ##Private
resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-north-1c"
  tags = {
    Name = "Private Subnet-2"
  }
}
# COMBINE PRIVATE SUBNETS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id ]  #if multi AZ add another subnet
}
# PRIVATE
  # SECURITY GROUPS & RDS
resource "aws_security_group" "sg_for_rds" {
  name        = "my-db-sg"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    from_port   = 5432  # Postgress port
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.wasim-ec2-sg.id]
  }
}
# PRIVATE ROUTE TABLE
  #private route table without internet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private route_table"
  }
}
  #private subnet associated with the subnet
resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
  }
resource "aws_route_table_association" "private-route-table-association-2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
  }
resource "aws_db_instance" "my_db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"     # check that the storage type is free tier eligible
  engine               = "postgres"
  engine_version       = "17.4"
  instance_class       = "db.t3.micro"  #check that the instance class is free tier eligible
  db_name              = "dbdatabase" #map the db name, username and password to your credentials
  username             = "grocery_user"
  password             = "AbEd1184"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
      # Attach the DB security group
  vpc_security_group_ids = [aws_security_group.wasim-ec2-sg.id]
  tags = {
    Name = "ec2_to_postgres_rds"
  }
}










