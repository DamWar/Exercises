variable "region" {
  type = string
}

variable "storage" {
  type = object({
    name = string
    pricing = object({
      tier        = string
      replication = string
    })
  })
}