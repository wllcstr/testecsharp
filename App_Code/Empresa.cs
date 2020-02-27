public class Empresa {
    public int id { get; set; }
    public string fantasia { get; set; }
    public string uf { get; set; }
    public string cnpj { get; set; }

    public Empresa() {
        this.id = 0;
        this.fantasia = string.Empty;
        this.uf = string.Empty;
        this.cnpj = string.Empty;
    }
}