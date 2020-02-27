<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cadforne.aspx.cs" Inherits="cadforne" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Cadastro de Fornecedor</title>
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
    <link href="css/cadforne.aspx.css" rel="stylesheet">
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
    <!-- Mask -->
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"></script>
    <!-- Javascript personalizado -->
    <script src="js/cadforne.aspx.js"></script>
</head>
<body>
    <div class="progress">
        <div class="indeterminate"></div>
    </div>
    <div class="container-fluid">
        <div class="jumbotron jumbotron-fluid">
            <form id="fcadforne" runat="server">
                <asp:ScriptManager ID="smcadforne" runat="server" EnablePageMethods="true">
                </asp:ScriptManager>
                <div class="row">
                    <h3 class="unique-color">Cadastro de Fornecedor</h3>
                </div>
                <div class="row">
                    <div class="col-6">
                        <h5 class="border-bottom">Dados Cadastrais</h5>
                        <div class="row">
                            <div class="col label">
                                <label class="lbl" for="nome">Nome</label>
                            </div>
                            <div class="col">
                                <input type="text" id="nome" name="nome" class="form-control" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col label">
                                <label class="lbl" for="doc">Documento</label>
                            </div>
                            <div class="col">
                                <input type="text" id="doc" name="doc" class="form-control" maxlength="14" />
                                <span id="err_doc" class="err"></span>
                            </div>
                        </div>
                        <div class="row pfview">
                            <div class="col label">
                                <label class="lbl" for="rg">RG</label>
                            </div>
                            <div class="col">
                                <input type="text" id="rg" name="rg" maxlength="10" class="form-control" />
                            </div>
                        </div>
                        <div class="row pfview">
                            <div class="col label">
                                <label class="lbl" for="dtnas">Data de Nascimento</label>
                            </div>
                            <div class="col">
                                <input type="text" id="dtnas" name="dtnas" class="form-control" />
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <h5 class="border-bottom">Contatos</h5>
                        <div class="row">
                            <ul id="contatos" class="list-group list-group-flush">
                                <li class="list-group-item">
                                    <div class="d-flex flex-row">
                                        <input type="text" class="nomecon flex-grow-1 form-control" placeholder="Nome" />
                                        <input type="text" class="fonecon form-control" placeholder="Telefone" />
                                        <a title="Excluir Contato" class="btn-floating rem_fone text-white btn-primary"><i class="fas fa-trash"></i></a>
                                    </div>
                                </li>
                            </ul>
                            <a id="add_fone" title="Adicionar Contato" class="btn-floating text-white unique-color"><i class="fas fa-address-book"></i></a>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col text-center">
                        <button type="button" id="cancel" title="Cancelar" class="addc btn unique-color text-white waves-effect cancel"><i class="fas fa-ban mr-2" aria-hidden="true"></i>Cancelar</button>
                        <button type="button" id="cad_for" title="Salvar" class="addc btn unique-color text-white waves-effect save"><i class="fas fa-save mr-2" aria-hidden="true"></i>Salvar</button>
                        <button type="button" id="rem_for" title="Excluir" class="addc btn btn-primary waves-effect save"><i class="fas fa-trash mr-2" aria-hidden="true"></i>Excluir</button>
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
                    <p>Excluir o cadastro deste fornecedor irá excluir também todos os seus contatos. Deseja prosseguir?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn unique-color text-white" data-dismiss="modal">Fechar</button>
                    <button type="button" id="del_forne" class="btn btn-primary">Prosseguir</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
