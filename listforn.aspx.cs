using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;



public partial class listforn : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    [WebMethod()]
    public static Empresa[] GetEmpresas() {
        try {
            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {

                    sqlComm.CommandText = "SELECT * FROM empresas";
                    DataTable dt = new DataTable();

                    dt.Load(sqlComm.ExecuteReader());
                    sqlComm.ExecuteReader().Close();

                    if (dt.Rows.Count < 1)
                        return null;

                    // cria a listinha das empresas
                    List<Empresa> lempresas = new List<Empresa>();

                    foreach (DataRow dr in dt.Rows) {

                        Empresa e = new Empresa();

                        e.id = (int)dr["emp_id"];
                        e.fantasia = dr["emp_fantasia"].ToString().Trim().ToUpper();
                        e.uf = dr["emp_uf"].ToString().Trim();
                        string doc = dr["emp_cnpj"].ToString().Trim();
                        doc = Utils.formataDoc(doc);
                        if (doc == "fail")
                            doc = dr["emp_cnpj"].ToString().Trim();
                        e.cnpj = doc;

                        lempresas.Add(e);
                    }

                    if (lempresas.Count > 0)
                        return lempresas.ToArray();

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
    public static Fornecedor[] GetFornecedores(int empresa) {
        try {
            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {

                    sqlComm.Parameters.AddWithValue("@empre", empresa);
                    sqlComm.CommandText = "SELECT * FROM fornecedores WHERE for_empre = @empre";
                    DataTable dt = new DataTable();
                    dt.Load(sqlComm.ExecuteReader());
                    sqlComm.ExecuteReader().Close();

                    if (dt.Rows.Count == 0)
                        return null;

                    List<Fornecedor> lfornecedores = new List<Fornecedor>();

                    foreach (DataRow dr in dt.Rows) {
                        Fornecedor f = new Fornecedor();

                        f.id = (int)dr["for_id"];
                        f.nome = dr["for_nome"].ToString().Trim();
                        f.dtcad = string.Format("{0:dd/MM/yyyy}", dr["for_dtcad"]);
                        if (dr["for_dtnas"] != DBNull.Value)
                            f.dtnas = string.Format("{0:dd/MM/yyyy}", dr["for_dtnas"]);
                        f.doc = Utils.formataDoc(dr["for_doc"].ToString().Trim());
                        if (dr["for_rg"] != DBNull.Value)
                            f.rg = dr["for_rg"].ToString().Trim();

                        lfornecedores.Add(f);
                    }

                    return lfornecedores.ToArray();
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
    public static bool delEmpresa(int empresa) {
        try {
            using (SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {
                    // nesse caso, transação
                    SqlTransaction t = conn.BeginTransaction();

                    // define a transação
                    sqlComm.Transaction = t;

                    // deleta a empresa, o restante vai pois tem cascade nas FK
                    sqlComm.Parameters.AddWithValue("@empre", empresa);
                    sqlComm.CommandText = "DELETE FROM empresas WHERE emp_id = @empre";

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
}