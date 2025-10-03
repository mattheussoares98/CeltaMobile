enum BrazilStates {
  acre('AC', 'Acre'),
  alagoas('AL', 'Alagoas'),
  amapa('AP', 'Amapá'),
  amazonas('AM', 'Amazonas'),
  bahia('BA', 'Bahia'),
  ceara('CE', 'Ceará'),
  distritoFederal('DF', 'Distrito Federal'),
  espiritoSanto('ES', 'Espírito Santo'),
  goias('GO', 'Goiás'),
  maranhao('MA', 'Maranhão'),
  matoGrosso('MT', 'Mato Grosso'),
  matoGrossoDoSul('MS', 'Mato Grosso do Sul'),
  minasGerais('MG', 'Minas Gerais'),
  para('PA', 'Pará'),
  paraiba('PB', 'Paraíba'),
  parana('PR', 'Paraná'),
  pernambuco('PE', 'Pernambuco'),
  piaui('PI', 'Piauí'),
  rioDeJaneiro('RJ', 'Rio de Janeiro'),
  rioGrandeDoNorte('RN', 'Rio Grande do Norte'),
  rioGrandeDoSul('RS', 'Rio Grande do Sul'),
  rondonia('RO', 'Rondônia'),
  roraima('RR', 'Roraima'),
  santaCatarina('SC', 'Santa Catarina'),
  saoPaulo('SP', 'São Paulo'),
  sergipe('SE', 'Sergipe'),
  tocantins('TO', 'Tocantins');

  final String uf;
  final String name;
  const BrazilStates(this.uf, this.name);
}
