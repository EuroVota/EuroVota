variable "read_capacity" {
  default = 5
}

variable "write_capacity" {
  default = 5
}

variable "users_instance_type"{
  default = "t2.micro"
}


variable "key_pair" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCI8OXi6nzy4gUcmm7M4a0BxqdKweJC5EBxJ4S3C6zL+5X1e67FNOolqXXjEd4fXvwIZgerHBEDfdbV0/7UusUrErFWBog/JH4yMb3zoGp7g+lYB9HbcbXOerSlZFBBfBtsWn62rkXRFIW4guoz3Ii3Dzad8/MI5U8NsAG0pL07qJp6JGJ+pZaHyyEw4CwapT/hTEGdD9e5YXbAWLyYO2N3ktdVkP4mhz7+qYN0wkVHyf22loBQ6gxfHIrRlYwGs0C3z/hFzTRWqA/Qt33u88KIvYI9vpJbmiJdD0JnTVGLrRN4yW1/kb+dBDyXzjxtxI2fDp/7m/9bZpSK8ucfrwUammBZJ6BnppLCYf/vUuEkuF7+0ygzghgffg4uKiPqpGbEMhdHH1rjid9j3m2h7gOx5UoFmN9Mu2sesj9ebE0pKVFi3/Bt6i06NwdKVaPSE2U9EA370+eOZjw3RmfDvHajTTqXDPHyL+CT8w+EG5C5ggBR28YkDUEdq2ONsquKKJc= root@ip-10-0-101-210"
}
