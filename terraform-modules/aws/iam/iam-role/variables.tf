variable "environment" {
  type = string
}
variable "assume_role_policy" {
  type = string
}
variable "iam_role_name" {
  type = string
}
variable "owner" {
  type = string
}
variable "iam_role_description" {
  type    = string
  default = null
}