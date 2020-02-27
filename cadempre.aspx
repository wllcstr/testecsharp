<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cadempre.aspx.cs" Inherits="cadempre" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cadastro Empresa</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css">
    <!-- Google Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap">
    <!-- Bootstrap core CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Design Bootstrap -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.13.0/css/mdb.min.css" rel="stylesheet">
    <!-- MDB Datatables -->
    <link href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css" rel="stylesheet">
    <!-- Folha de estilo personalizada -->
    <link href="css/cadempre.aspx.css" rel="stylesheet">
    <link href="css/progress.css" rel="stylesheet">


    <!-- JQuery -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <!-- Bootstrap tooltips -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.4/umd/popper.min.js"></script>
    <!-- Bootstrap core JavaScript -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.4.1/js/bootstrap.min.js"></script>
    <!-- MDB core JavaScript -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.13.0/js/mdb.min.js"></script>
    <!-- MDB Datatables -->
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
    <!-- Javascript personalizado -->
    <script src="js/cadempre.aspx.js"></script>
</head>
<body>
    <div class="progress">
        <div class="indeterminate"></div>
    </div>
    <div class="container-fluid">
        <div class="jumbotron jumbotron-fluid">
            <form id="fcadempre" runat="server">
                <asp:ScriptManager ID="smcadempre" runat="server" EnablePageMethods="true">
                </asp:ScriptManager>
                <div class="row">
                    <h3 class="unique-color">Cadastro de Empresa</h3>
                </div>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col label">
                            <label class="lbl" for="nfanta">Nome Fantasia</label>
                        </div>
                        <div class="col">
                            <input type="text" id="nfanta" name="nfanta" class="form-control" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col label">
                            <label class="lbl" for="cnpj">CNPJ</label>
                        </div>
                        <div class="col">
                            <input type="text" id="cnpj" name="cnpj" maxlength="14" class="form-control" />
                            <span id="err_cnpj" class="err"></span>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col label">
                            <label class="lbl" for="uf">Estado</label>
                        </div>
                        <div class="col">
                            <select id="uf" name="uf" class="browser-default custom-select">
                                <option value="AC">Acre</option>
                                <option value="AL">Alagoas</option>
                                <option value="AP">Amapá</option>
                                <option value="AM">Amazonas</option>
                                <option value="BA">Bahia</option>
                                <option value="CE">Ceará</option>
                                <option value="DF">Distrito Federal</option>
                                <option value="ES">Espírito Santo</option>
                                <option value="GO">Goiás</option>
                                <option value="MA">Maranhão</option>
                                <option value="MT">Mato Grosso</option>
                                <option value="MS">Mato Grosso do Sul</option>
                                <option value="MG">Minas Gerais</option>
                                <option value="PA">Pará</option>
                                <option value="PB">Paraíba</option>
                                <option value="PR">Paraná</option>
                                <option value="PE">Pernambuco</option>
                                <option value="PI">Piauí</option>
                                <option value="RJ">Rio de Janeiro</option>
                                <option value="RN">Rio Grande do Norte</option>
                                <option value="RS">Rio Grande do Sul</option>
                                <option value="RO">Rondônia</option>
                                <option value="RR">Roraima</option>
                                <option value="SC">Santa Catarina</option>
                                <option value="SP">São Paulo</option>
                                <option value="SE">Sergipe</option>
                                <option value="TO">Tocantins</option>
                            </select>

                        </div>

                    </div>
                    <div class="row">
                        <div class="col text-center">
                            <button type="button" id="cancel" title="Cancelar" class="addc btn unique-color waves-effect cancel text-white"><i class="fas fa-ban mr-2" aria-hidden="true"></i>Cancelar</button>
                            <button type="button" id="cad_emp" title="Salvar" class="addc btn unique-color waves-effect save text-white"><i class="fas fa-save mr-2" aria-hidden="true"></i>Salvar</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div id="modal" class="modal fade" role="dialog" aria-hidden="true" aria-labelledby="ModalPadrao">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ModalPadrao">Alerta do Sistema</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn unique-color text-white" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
