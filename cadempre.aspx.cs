using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class cadempre : System.Web.UI.Page {
    protected void Page_Load(object sender, EventArgs e) {

    }

    [WebMethod()]
    public static string validaDoc(string cnpj) {
        string ret = Utils.validaDoc(cnpj);
        if (ret == "ok")
            return string.Empty;
        return ret;
    }

    [WebMethod()]
    public static bool salvaEmpresa(string fanta, string cnpj, string uf) {
        try {
            if (!string.IsNullOrEmpty(validaDoc(cnpj)))
                return false;

            using(SqlConnection conn = new SqlConnection(Utils.getConnectionString())) {
                SqlCommand sqlComm = new SqlCommand();
                sqlComm.CommandType = System.Data.CommandType.Text;
                sqlComm.Connection = conn;

                conn.Open();

                try {
                    sqlComm.Parameters.AddWithValue("@cnpj", cnpj);
                    sqlComm.CommandText = "SELECT * FROM empresas WHERE emp_cnpj = @cnpj";
                    // testa pra nao cadastrar cnpj duplicado
                    SqlDataReader dr = sqlComm.ExecuteReader();
                    if (dr.HasRows)
                        return false;
                    dr.Close();

                    sqlComm.Parameters.Clear();

                    sqlComm.Parameters.AddWithValue("@fanta", fanta);
                    sqlComm.Parameters.AddWithValue("@uf", uf);
                    sqlComm.Parameters.AddWithValue("@cnpj", cnpj);
                    sqlComm.CommandText = "INSERT INTO empresas (emp_fantasia, emp_uf, emp_cnpj) VALUES (@fanta, @uf, @cnpj)";
                    int count = sqlComm.ExecuteNonQuery();

                    if (count > 0)
                        return true;

                    return false;
                } catch(Exception ex) {
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