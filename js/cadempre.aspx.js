$(document).ready(window_onload);

function window_onload() {
    hideLoading();
    $("#cnpj").focusout(validaCNPJ);
    $("#cnpj").focus(function () {
        $("#err_cnpj").text("");
        $("#err_cnpj").hide();
    });
    $("#cad_emp").click(saveEmpre);
    $("#cancel").click(function () {
        window.history.back();
    });
}

var docvalid = false;

function validaCNPJ() {
    try {
        var cnpj = $("#cnpj").val();
        if (cnpj.length != 14) {
            $("#err_cnpj").show();
            $("#err_cnpj").text("CNPJ deve ter 14 dígitos");
            return;
        }

        showLoading();
        PageMethods.validaDoc(cnpj, validaDoc_cb);
        
    } catch (e) {
        showMessage(e.message);
    }
}

function validaDoc_cb(PsReturn) {
    hideLoading();
    if (PsReturn) {
        $("#err_cnpj").show();
        $("#err_cnpj").text(PsReturn);
    } else
        docvalid = true;
}

function saveEmpre() {
    try {
        var fanta = $("#nfanta").val();
        var cnpj = $("#cnpj").val();
        var uf = $("#uf").val();

        if (fanta.length < 3) {
            showMessage("Nome da empresa muito curto");
            return;
        }

        if (fanta && cnpj && uf && docvalid) {
            showLoading();
            PageMethods.salvaEmpresa(fanta, cnpj, uf, salvaEmpresa_cb);
        } else {
            showMessage("Todos os campos são de preenchimento obrigatório");
        }

    } catch (e) {
        showMessage(e.message);
    }
}

function salvaEmpresa_cb(PbReturn) {
    hideLoading();
    if (!PbReturn) {
        showMessage("Empresa não cadastrada\nVerifique os dados e tente novamente");
        return;
    }
    showMessage("Cadastro realizado com sucesso!");
    window.history.back();
}


function limpa() {
    $("input").val("");
}

function showLoading() {
    $(".progress").css("visibility", "visible");
}

function hideLoading() {
    $(".progress").css("visibility", "hidden");
}

function showMessage(PsMsg) {
    $("#modal .modal-body p").text(PsMsg);
    $('#modal').modal();
}