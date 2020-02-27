<%@ Page Language="C#" AutoEventWireup="true" CodeFile="listforn.aspx.cs" Inherits="listforn" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cadastro Fornecedores</title>
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
    <link href="css/listforn.aspx.css" rel="stylesheet">
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
    <script src="js/listforn.aspx.js"></script>
</head>
<body>
    <div class="progress">
        <div class="indeterminate"></div>
    </div>
    <div class="container-fluid">
        <div class="jumbotron jumbotron-fluid">
            <form id="flistforn" runat="server">
                <asp:ScriptManager ID="smlistforn" runat="server" EnablePageMethods="true">
                </asp:ScriptManager>
                <div class="row">
                    <h3 class="unique-color">Lista de Fornecedores</h3>
                </div>
                <div class="row">
                    <p>Selecione a empresa para visualizar os fornecedores relacionados.</p>
                </div>
                <div class="row">
                    <div class="input-field col s12">
                        <select id="empresa" class="browser-default custom-select">
                            <option value="0" selected>- Selecione a Empresa -</option>
                        </select>
                    </div>

                    <button type="button" id="add_emp" data-tooltip="Nova Empresa" title="Nova Empresa" class="addc btn text-white unique-color waves-effect tooltipped"><i class="fas fa-plus-circle" aria-hidden="true"></i></button>
                    <button type="button" id="rem_emp" data-tooltip="Remover Empresa" title="Remover Empresa" class="addc btn text-white unique-color waves-effect tooltipped"><i class="fas fa-trash" aria-hidden="true"></i></button>
                </div>
                <div class="row">
                    <button type="button" id="add_for" class="addf btn text-white unique-color waves-effect"><i class="fas fa-address-card mr-2" aria-hidden="true"></i>Adicionar Fornecedor</button>
                </div>
                <div class="row fcontainer table-responsive">
                    <table id="tfornecedores" class="table table-striped table-sm" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th scope="col" class="th">Fornecedor</th>
                                <th scope="col" class="th">CPF/CNPJ</th>
                                <th scope="col" class="th">Cadastrado em</th>
                            </tr>
                        </thead>
                        <tbody id="listaf">
                        </tbody>
                    </table>
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

    <div id="askmodal" class="modal fade" role="dialog" aria-hidden="true" aria-labelledby="ModalAsk">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ModalAsk">Atenção</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p>Excluir o cadastro desta empresa irá excluir também os fornecedores relacionados, bem como todos os seus contatos. Deseja prosseguir?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn unique-color text-white" data-dismiss="modal">Fechar</button>
                    <button type="button" id="del_empre" class="btn btn-primary">Prosseguir</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
