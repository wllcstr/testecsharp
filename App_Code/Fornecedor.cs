
public class Fornecedor {
    public int id { get; set; }
    public string nome { get; set; }
    public string dtcad { get; set; }
    public string dtnas { get; set; }
    public string doc { get; set; }
    public string rg { get; set; }
    public int empre { get; set; }
    public Contato[] contatos { get; set; }

    public Fornecedor() {
        this.id = 0;
        this.nome = string.Empty;
        this.dtcad = string.Empty;
        this.dtnas = string.Empty;
        this.doc = string.Empty;
        this.rg = string.Empty;
        this.empre = 0;
        this.contatos = null;
    }

}
