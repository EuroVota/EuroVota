
variable "read_capacity" {
  description = "Capacidad de lectura provisionada para DynamoDB"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Capacidad de escritura provisionada para DynamoDB"
  type        = number
  default     = 5
}

variable "autoscaling_min_read_capacity" {
  description = "Capacidad mínima de lectura para el autoescalado de DynamoDB"
  type        = number
  default     = 5
}

variable "autoscaling_max_read_capacity" {
  description = "Capacidad máxima de lectura para el autoescalado de DynamoDB"
  type        = number
  default     = 100
}

variable "autoscaling_min_write_capacity" {
  description = "Capacidad mínima de escritura para el autoescalado de DynamoDB"
  type        = number
  default     = 5
}

variable "autoscaling_max_write_capacity" {
  description = "Capacidad máxima de escritura para el autoescalado de DynamoDB"
  type        = number
  default     = 100
}
