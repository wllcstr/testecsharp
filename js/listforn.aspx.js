$(document).ready(window_onload);

var empre = 0;

function window_onload() {

    $('.tooltipped').tooltip();

    $('#tfornecedores').DataTable({
        "pagingType": "simple",
        "pageLength": 100,
        "columnDefs": [
            { "width": "140px", "targets": [1, 2] }
        ]
    });

    // Tira o label do search na marra
    $(".dataTables_filter input").attr("placeholder", "buscar");
    $(".dataTables_filter input").addClass("form-control");
    $(".dataTables_filter label").css("visibility", "hidden");
    $(".dataTables_filter label input").css("visibility", "visible");

    limpa();

    buscaEmpresas();

    $("#add_emp").click(function () {
        window.location = "/cadempre.aspx";
    });

    $("#rem_emp").click(deletaEmpresa);
    $("#empresa").change(setEmpresa);
    $("#del_empre").click(removeEmpresa);
    $("#add_for").click(clickAddFornec);


}

function removeEmpresa() {
    if (empre == 0)
        return;
    showLoading();
    try {
        showLoading();
        PageMethods.delEmpresa(empre, delEmpresa_cb)
    } catch (e) {
        showMessage(e.message);
    }
}

function delEmpresa_cb(PbReturn) {
    if (PbReturn) {
        showMessage("A empresa e seus fornecedores foram excluidos.");
        window.setTimeout(function () {
            location.reload();
        }, 1000);
    } else
        showMessage("Falha ao remover a empresa.");
}

function deletaEmpresa() {
    if (empre == 0) {
        showMessage("Nenhume empresa selecionada para excluir");
        return;
    }
    $('#askmodal').modal();
    $("#askmodal").modal("open");

}

function setEmpresa() {
    limpa();
    empre = $(this).val();
    if (empre > 0) {

        showLoading();
        $("#add_for").attr("disabled", false);
        $("#rem_emp").attr("disabled", false);
        PageMethods.GetFornecedores(empre, montaFornecedores);
    }
}

function clickAddFornec() {
    empre = $("#empresa").val();
    window.location = "/cadforne.aspx?empre=" + empre;
}

function montaFornecedores(PlReturn) {
    if (PlReturn != null) {
        var table = $('#tfornecedores').DataTable();
        table.clear().draw();
        for (var i = 0; i < PlReturn.length; i++) {

            // hackzinho para poder fazer o sort pelo date no grid
            var date = PlReturn[i].dtcad.split("/");
            var hidden_date = date[2] + "/" + date[1] + "/" + date[0];
            var true_date = '<span class="hd">' + hidden_date + '</span>' + PlReturn[i].dtcad;
            var linkfor = '<a href="/cadforne.aspx?forne=' + PlReturn[i].id + '&empre=' + empre + '"><i class="fas fa-user-edit mr-1"></i>' + PlReturn[i].nome + '</a>';
            //var row = '<tr><td>' + linkfor + '</td><td>' + PlReturn[i].doc + '</td><td><span class="hd">' + hidden_date + '</span>' + PlReturn[i].dtcad + '</td></tr>';

            table.row.add([linkfor, PlReturn[i].doc, true_date]).draw();

        }

        hideLoading();
    } else {
        hideLoading();
        $("#listaf").append('<p class="nofornec">Empresa sem fornecedores cadastrados.</p>');
    }
}

function limpa() {
    $("#listaf").empty();
    $("#rem_emp").attr("disabled", true);
    $("#add_for").attr("disabled", true);

}

function buscaEmpresas() {
    limpa();
    showLoading();
    try {
        PageMethods.GetEmpresas(montaEmpresas);
    } catch (e) {
        showMessage(e.message);
    }
}

function montaEmpresas(PlReturn) {
    hideLoading();
    if (PlReturn != null) {
        for (var i = 0; i < PlReturn.length; i++) {
            var t = '<option value="' + PlReturn[i].id + '">' + PlReturn[i].fantasia + '</option>';
            $("#empresa").append(t);
        }
    } else {
        showMessage("Não há empresas cadastradas");
    }
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