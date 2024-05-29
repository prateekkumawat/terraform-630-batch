variable "testbox" {
  type = list(string)
  default = [ "testbox1", "testbox2", "testbox3", "testbox4", "testbox5" ]
}
variable "multivpc" {
  type = list(string)
  default = [ "dev", "prod", "test"]
}

variable "multivpc_cidr" {
  type = list(string)
  default = [ "10.0.0.0/22", "10.0.7.0/22", "10.0.20.0/22" ]
}

variable "xyz" {
  type = map(list(string))
  default = {
    vpcname = [ "dev", "prod", "test" ]
    vpcblocks = [ "10.0.0.0/22", "10.0.7.0/22", "10.0.20.0/22" ]
  }

}