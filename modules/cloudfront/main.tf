# Modificador de 4 valores en minuscula

resource "random_string" "suffix_cf" {
  length    = 6
  min_lower = 6
  special   = false
}
