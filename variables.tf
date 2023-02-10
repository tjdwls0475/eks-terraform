variable "region" {
    type = string
    default = "ap-northeast-1"
}

variable "cidr_block" {
    type = string
    default = "84.20.10.0/24"
}

variable "secondary_cidr" {
    type = string
    default = "84.20.11.0/24"
}