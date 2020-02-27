using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Utils
/// </summary>
public class Utils {
    /// <summary>
    /// Formata o documento
    /// </summary>
    /// <param name="doc">RG ou CPF</param>
    /// <returns>dpcumento formatado</returns>
    public static string formataDoc(string doc) {
        try {
            string format = string.Empty;
            switch (doc.Length) {
                case 11:
                    format = string.Concat(doc.Substring(0, 3), ".", doc.Substring(3, 3), ".", doc.Substring(6, 3), "-", doc.Substring(9));
                    break;
                case 14:
                    format = string.Concat(doc.Substring(0, 2), ".", doc.Substring(2, 3), ".", doc.Substring(5, 3), "/", doc.Substring(8, 4), "-", doc.Substring(12));
                    break;
                default:
                    format = "fail";
                    break;
            }
            return format;
        } catch (Exception ex) {
            throw ex;
        }
    }

    /// <summary>
    /// Valida o documento digitado, tanto cpf quanto cnpj
    /// </summary>
    /// <param name="doc">documento digitado</param>
    /// <returns>ok para documento digitádo válido, ou string de documento inválido</returns>
    public static string validaDoc(string doc) {
        try {
            if (string.IsNullOrEmpty(doc))
                return "Nenhum documento digitado";

            if (doc.Length != 11 && doc.Length != 14)
                return "Formato do documento inválido";

            if (doc.Length == 11) {
                if (validaCPF(doc))
                    return "ok";
                else
                    return "CPF inválido";
            } else {
                if (validaCNPJ(doc))
                    return "ok";
                else
                    return "CNPJ inválido";
            }

        } catch (Exception ex) {
            throw ex;
        }
    }

    /// <summary>
    /// Função para validar o cnpj pelo DV
    /// </summary>
    /// <param name="cnpj">cnpj digitado</param>
    /// <returns>true para cnpj válido, false para inválido</returns>
    private static bool validaCNPJ(string cnpj) {
        try {
            int a = int.Parse(cnpj.Substring(0, 1));
            int b = int.Parse(cnpj.Substring(1, 1));
            int c = int.Parse(cnpj.Substring(2, 1));
            int d = int.Parse(cnpj.Substring(3, 1));
            int e = int.Parse(cnpj.Substring(4, 1));
            int f = int.Parse(cnpj.Substring(5, 1));
            int g = int.Parse(cnpj.Substring(6, 1));
            int h = int.Parse(cnpj.Substring(7, 1));
            int i = int.Parse(cnpj.Substring(8, 1));
            int j = int.Parse(cnpj.Substring(9, 1));
            int k = int.Parse(cnpj.Substring(10, 1));
            int l = int.Parse(cnpj.Substring(11, 1));
            int m = int.Parse(cnpj.Substring(12, 1));
            int n = int.Parse(cnpj.Substring(13, 1));

            int tm = 0, tn = 0;

            int s = a * 5 + b * 4 + c * 3 + d * 2 + e * 9 + f * 8 + g * 7 + h * 6 + i * 5 + j * 4 + k * 3 + l * 2;

            if (s % 11 > 1)
                tm = 11 - (s % 11);

            if (m != tm)
                return false;

            s = a * 6 + b * 5 + c * 4 + d * 3 + e * 2 + f * 9 + g * 8 + h * 7 + i * 6 + j * 5 + k * 4 + l * 3 + m * 2;

            if (s % 11 > 1)
                tn = 11 - (s % 11);

            if (n != tn)
                return false;

            return true;

        } catch (Exception ex) {
            throw ex;
        }
    }

    /// <summary>
    /// Função que valida o CPF através do DV
    /// </summary>
    /// <param name="cpf">cpf digitado</param>
    /// <returns>true para cpf válido, false para inválido</returns>
    private static bool validaCPF(string cpf) {
        try {
            int a = int.Parse(cpf.Substring(0, 1));
            int b = int.Parse(cpf.Substring(1, 1));
            int c = int.Parse(cpf.Substring(2, 1));
            int d = int.Parse(cpf.Substring(3, 1));
            int e = int.Parse(cpf.Substring(4, 1));
            int f = int.Parse(cpf.Substring(5, 1));
            int g = int.Parse(cpf.Substring(6, 1));
            int h = int.Parse(cpf.Substring(7, 1));
            int i = int.Parse(cpf.Substring(8, 1));
            int j = int.Parse(cpf.Substring(9, 1));
            int k = int.Parse(cpf.Substring(10, 1));

            int tj = 0, tk = 0;

            int s = 10 * a + 9 * b + 8 * c + 7 * d + 6 * e + 5 * f + 4 * g + 3 * h + 2 * i;

            if (s % 11 > 1)
                tj = 11 - (s % 11);

            if (tj != j)
                return false;

            s = 11 * a + 10 * b + 9 * c + 8 * d + 7 * e + 6 * f + 5 * g + 4 * h + 3 * i + 2 * j;

            if (s % 11 > 1)
                tk = 11 - (s % 11);

            if (tk != k)
                return false;

            return true;
        } catch (Exception ex) {
            throw ex;
        }
    }

    /// <summary>
    /// Função que fornece a string de conexão com o banco de dados
    /// </summary>
    /// <returns>string de conexão com o banco de dados</returns>
    public static string getConnectionString() {
        try {
            // Instancia as constantes de conexão

            //nome do servidor
            string server = "Server=35.238.140.72";
            server = string.Concat(server, ";");

            //nome do do banco de dados
            string db = "Database=cadfornecedores";
            db = string.Concat(db, ";");

            //usuário
            string user = "User Id=sqlserver";
            user = string.Concat(user, ";");

            //senha
            string pass = "Password=q1w2e3r4";
            pass = string.Concat(pass, ";");

            string compl = ";MultipleActiveResultSets=True;";

            string sConnString = string.Concat(server, db, user, pass, compl);

            return sConnString;

        } catch (Exception ex) {
            throw ex;
        }
    }
}
