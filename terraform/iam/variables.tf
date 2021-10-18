variable "name" {
  type = string
  description = "prefix used for resources created in this module"
}

variable "role_suffix" {
  type = string
  description = "suffix for role resource(s) name"
  default = "role"
}

variable "policy_suffix" {
  type = string
  description = "suffix for policy resource(s) name"
  default = "policy"
}

variable "group_suffix" {
  type = string
  description = "suffix for group resource(s) name"
  default = "group"
}

variable "user_suffix" {
  type = string
  description = "suffix for user resource(s) name"
  default = "user"
}

variable "account_id" {
  type = string
  description = "Target AWS Account ID"
}
