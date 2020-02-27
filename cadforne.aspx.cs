using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cadforne : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    [WebMethod()]
    public static Empresa getEmpre(int empre) {
        try {
            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {
                    sqlComm.Parameters.AddWithValue("@empre", empre);
                    sqlComm.CommandText = "SELECT * FROM empresas WHERE emp_id = @empre";
                    DataTable dt = new DataTable();
                    dt.Load(sqlComm.ExecuteReader());
                    if (dt.Rows.Count == 0)
                        return null;

                    DataRow dr = dt.Rows[0];

                    Empresa e = new Empresa();

                    e.cnpj = dr["emp_cnpj"].ToString().Trim();
                    e.fantasia = dr["emp_fantasia"].ToString().Trim();
                    e.uf = dr["emp_uf"].ToString().Trim();

                    return e;

                } catch (Exception ex) {
                    throw ex;
                } finally {
                    conn.Close();
                }
            }
        } catch (Exception ex) {
            throw ex;
        }
    }


    [WebMethod()]
    public static bool salvaFornecedor(Fornecedor fornecedor) {
        try {
            //prepara o campo documento sem as pontuações
            fornecedor.doc = fornecedor.doc.Replace(".", "").Replace("-", "").Replace("/", "");
            if (!string.IsNullOrEmpty(validaDoc(fornecedor.doc)))
                return false;

            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {

                    // atualização de cadastro que já existe
                    if(fornecedor.id > 0) {
                        // transação, todas as vezes que vamos manipular mais de uma tabela
                        SqlTransaction ut = conn.BeginTransaction();
                        sqlComm.Transaction = ut;

                        // se nao tem cadastra
                        sqlComm.Parameters.Clear();
                        sqlComm.Parameters.AddWithValue("@fid", fornecedor.id);
                        sqlComm.Parameters.AddWithValue("@doc", fornecedor.doc);
                        sqlComm.Parameters.AddWithValue("@nome", fornecedor.nome);

                        sqlComm.CommandText = "UPDATE fornecedores SET for_nome = @nome, for_doc = @doc WHERE for_id = @fid";
                        if (fornecedor.doc.Length == 11) {
                            sqlComm.Parameters.AddWithValue("@rg", fornecedor.rg);
                            string dtnas = string.Format("{0:MM/dd/yyyy}", DateTime.Parse(fornecedor.dtnas));
                            sqlComm.Parameters.AddWithValue("@dtnas", dtnas);
                            sqlComm.CommandText = "UPDATE fornecedores SET for_nome = @nome, for_doc = @doc, for_rg = @rg, for_dtnas = @dtnas WHERE for_id = @fid";
                        }

                        int uaffected = sqlComm.ExecuteNonQuery();

                        if(uaffected != 1) {
                            ut.Rollback();
                            return false;
                        }

                        // queima os contatos todos e adiciona os atuais, menos trabalho do que ficar verificando as diferenças
                        sqlComm.Parameters.Clear();
                        sqlComm.Parameters.AddWithValue("@fid", fornecedor.id);
                        sqlComm.CommandText = "DELETE FROM telefonesf WHERE tel_fid = @fid";
                        sqlComm.ExecuteNonQuery();

                        // reposição
                        foreach (Contato c in fornecedor.contatos) {
                            // insere os contatos (telefones)
                            sqlComm.Parameters.Clear();
                            sqlComm.Parameters.AddWithValue("@fid", fornecedor.id);
                            sqlComm.Parameters.AddWithValue("@fone", c.fonec);
                            sqlComm.Parameters.AddWithValue("@nome", c.nomec);
                            sqlComm.CommandText = "INSERT INTO telefonesf (tel_fone, tel_contato, tel_fid) VALUES (@fone, @nome, @fid)";
                            int ucaffected = sqlComm.ExecuteNonQuery();
                            if (ucaffected < 1) {
                                ut.Rollback();
                                return false;
                            }
                        }
                        ut.Commit();
                        return true;
                    }


                    sqlComm.Parameters.AddWithValue("@empre", fornecedor.empre);
                    sqlComm.Parameters.AddWithValue("@doc", fornecedor.doc);

                    //verifica se já não tem esse fornecedor cadastrado para esta empresa
                    sqlComm.CommandText = "SELECT * FROM fornecedores WHERE for_empre = @empre AND for_doc = @doc";
                    SqlDataReader dr = sqlComm.ExecuteReader();
                    if (dr.HasRows)
                        return false;
                    dr.Close();

                    SqlTransaction t = conn.BeginTransaction();

                    sqlComm.Transaction = t;

                    // se nao tem cadastra
                    sqlComm.Parameters.Clear();
                    sqlComm.Parameters.AddWithValue("@empre", fornecedor.empre);
                    sqlComm.Parameters.AddWithValue("@doc", fornecedor.doc);
                    sqlComm.Parameters.AddWithValue("@nome", fornecedor.nome);
                    string dtcad = string.Format("{0:MM/dd/yyyy}", DateTime.Today);
                    sqlComm.Parameters.AddWithValue("@dtcad", dtcad);


                    sqlComm.CommandText = "INSERT INTO fornecedores (for_nome, for_dtcad, for_doc, for_empre) VALUES (@nome, @dtcad, @doc, @empre) SELECT CAST(scope_identity() AS int)";
                    if (fornecedor.doc.Length == 11) {
                        sqlComm.Parameters.AddWithValue("@rg", fornecedor.rg);
                        string dtnas = string.Format("{0:MM/dd/yyyy}", DateTime.Parse(fornecedor.dtnas));
                        sqlComm.Parameters.AddWithValue("@dtnas", dtnas);
                        sqlComm.CommandText = "INSERT INTO fornecedores (for_nome, for_dtcad, for_doc, for_empre, for_rg, for_dtnas) VALUES (@nome, @dtcad, @doc, @empre, @rg, @dtnas) SELECT CAST(scope_identity() AS int)";
                    }

                    int id_fornecedor = Convert.ToInt32(sqlComm.ExecuteScalar());

                    if (!(id_fornecedor > 0)) {
                        t.Rollback();
                        return false;
                    }


                    foreach (Contato c in fornecedor.contatos) {
                        // insere os contatos (telefones)
                        sqlComm.Parameters.Clear();
                        sqlComm.Parameters.AddWithValue("@fid", id_fornecedor);
                        sqlComm.Parameters.AddWithValue("@fone", c.fonec);
                        sqlComm.Parameters.AddWithValue("@nome", c.nomec);
                        sqlComm.CommandText = "INSERT INTO telefonesf (tel_fone, tel_contato, tel_fid) VALUES (@fone, @nome, @fid)";
                        int affected = sqlComm.ExecuteNonQuery();
                        if (affected < 1) {
                            t.Rollback();
                            return false;
                        }
                    }
                    t.Commit();

                    return true;
                } catch (Exception ex) {
                    throw ex;
                } finally {
                    conn.Close();
                }

            }


        } catch (Exception ex) {
            throw ex;
        }
    }

    [WebMethod()]
    public static Fornecedor getFornec(int codfor) {
        try {
            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {

                    sqlComm.Parameters.AddWithValue("@codfor", codfor);
                    sqlComm.CommandText = "SELECT for_nome, for_dtnas, for_doc, for_rg FROM fornecedores WHERE for_id = @codfor";
                    DataTable forDT = new DataTable();
                    SqlDataReader sdr = sqlComm.ExecuteReader();
                    forDT.Load(sdr);
                    sdr.Close();

                    if (forDT.Rows.Count == 1) {
                        DataRow fornecedores = forDT.Rows[0];
                        Fornecedor f = new Fornecedor();
                        f.nome = fornecedores["for_nome"].ToString().Trim();
                        f.dtnas = string.Format("{0:dd/MM/yyyy}", fornecedores["for_dtnas"]);
                        f.doc = Utils.formataDoc(fornecedores["for_doc"].ToString().Trim());
                        f.rg = fornecedores["for_rg"].ToString().Trim();

                        // busca os contatos
                        List<Contato> contatos = new List<Contato>();

                        // eu sei que é o mesmo parâmetro, mas é uma prática minha limpar antes de cada execução ¯\_(ツ)_/¯
                        sqlComm.Parameters.Clear();
                        sqlComm.Parameters.AddWithValue("@codfor", codfor);
                        sqlComm.CommandText = "SELECT * FROM telefonesf WHERE tel_fid = @codfor";
                        DataTable conDT = new DataTable();
                        conDT.Load(sqlComm.ExecuteReader()); // quando eu sei que não tem mais comandos de leitura eu não instancio o reader
                        sqlComm.ExecuteReader().Close();

                        foreach (DataRow telefone in conDT.Rows) {
                            Contato c = new Contato();
                            c.nomec = telefone["tel_contato"].ToString().Trim();
                            c.fonec = telefone["tel_fone"].ToString().Trim();
                            contatos.Add(c);
                        }

                        if (contatos.Count > 0)
                            f.contatos = contatos.ToArray();

                        return f;

                    }

                    return null;

                } catch (Exception ex) {
                    throw ex;
                } finally {
                    conn.Close();
                }
            }
        } catch (Exception ex) {
            throw ex;
        }
    }

    [WebMethod()]
    public static bool removeFornecedor(int codfor) {
        try {
            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {
                    // transação tbm
                    SqlTransaction t = conn.BeginTransaction();

                    // define 
                    sqlComm.Transaction = t;

                    // deleta o fornecedor, o restante vai no cascade
                    sqlComm.Parameters.AddWithValue("@fornec", codfor);
                    sqlComm.CommandText = "DELETE FROM fornecedores WHERE for_id = @fornec";
                    if (sqlComm.ExecuteNonQuery() > 0) {
                        t.Commit();
                        return true;
                    }
                    t.Rollback();
                    return false;

                } catch (Exception ex) {
                    throw ex;
                } finally {
                    conn.Close();
                }
            }
        } catch (Exception ex) {
            throw ex;
        }
    }

    [WebMethod()]
    public static string validaDoc(string doc) {
        string ret = Utils.validaDoc(doc);
        if (ret == "ok")
            return string.Empty;
        return ret;
    }
}