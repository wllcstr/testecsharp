$(document).ready(window_onload);

var empre = 0;

var oEmpre = null;

var cforne = 0;

function window_onload() {
    if (getUrlVars().length > 0) {
        if (getUrlVars()["empre"] > 0)
            empre = parseInt(getUrlVars()["empre"]);
        if (getUrlVars()["forne"] > 0)
            cforne = parseInt(getUrlVars()["forne"]);
    }

    $('#dtnas').mask('00/00/0000');
    $("#del_forne").click(deletaFornecedor);
    $("#doc").focusout(validaDoc);
    $("#doc").focus(function () {
        $("#err_doc").text("");
        $("#err_doc").hide();
    });

    $("#cad_for").click(validaForm);
    $("#cancel").click(function () {
        window.history.back();
    });

    if (empre == 0) {
        hideLoading();
        showMessage("É necessário selecionar uma empresa para cadastrar um fornecedor");
    } else {
        try {
            showLoading();
            PageMethods.getEmpre(empre, setEmpre);
        } catch (e) {
            showMessage(e.message);
        }
    }

    $("#add_fone").click(function () {
        addContato(null, null);
    });
    $("#rem_for").hide();
    $(".pfview").hide();

    if (cforne > 0) {
        try {
            showLoading();
            PageMethods.getFornec(cforne, setFornec);
        } catch (e) {
            showMessage(e.message);
        }
    }
}

function setFornec(PoReturn) {
    hideLoading();
    if (PoReturn != null) {
        if (PoReturn.nome.indexOf("ERRO") > -1)
            showMessage(PoReturn.nome.split(":")[1]);
        else {
            $("#nome").val(PoReturn.nome);
            $("#doc").val(PoReturn.doc);
            validaDoc();
            $("#rg").val(PoReturn.rg);
            $("#dtnas").val(PoReturn.dtnas);
            $("#rem_for").show();
            $("#rem_for").click(remFornecedor);
            if (PoReturn.contatos != null) {
                $("#contatos").empty();
                for (var i = 0; i < PoReturn.contatos.length; i++) {
                    addContato(PoReturn.contatos[i].nomec, PoReturn.contatos[i].fonec);
                }
            }
        }
    } else
        showMessage("Falha ao buscar dados do fornecedor.");
}

function remFornecedor() {
    if (cforne == 0) {
        showMessage("Nenhum fornecedor selecionado.");
    }
    $('#askmodal').modal();
    $("#askmodal").modal("open");
}

function deletaFornecedor() {
    if (cforne > 0) {
        try {
            showLoading();
            PageMethods.removeFornecedor(cforne, removeFornecedor_cb);
        } catch (e) {
            showMessage(e.message);
        }
    }
}

function removeFornecedor_cb(PbReturn) {
    hideLoading();
    if (PbReturn) {
        showMessage("Cadastro do fornecedor foi excluído com sucesso!");
        window.setTimeout(function () {
            window.location = "/listforn.aspx";
        }, 2000);
    } else 
        showMessage("Não foi possível excluor o cadastro do fornecedor.");
        
}

function addContato(nomec, fonec) {
    
    var ncontato = '<li class="list-group-item"><div class="d-flex flex-row"><input type="text" class="nomecon flex-grow-1 form-control" placeholder="Nome" /><input type="text" class="fonecon form-control" placeholder="Telefone" /><a title="Excluir Contato" class="btn-floating rem_fone text-white btn-primary"><i class="fas fa-trash"></i></a></div></li>';
    if (fonec)
        ncontato = '<li  class="list-group-item"><div class="d-flex flex-row"><input type="text" class="nomecon flex-grow-1 form-control" placeholder="Nome" value="' + nomec + '" /><input type="text" class="fonecon form-control" placeholder="Telefone" value="' + fonec + '" /><a title="Excluir Contato" class="btn-floating rem_fone text-white btn-primary"><i class="fas fa-trash"></i></a></div></li>';
    $("#contatos").append(ncontato);
    $(".rem_fone").click(function () {
        $(this).parent().parent().remove();
    });
}

function validaForm() {
    var nome = $("#nome").val();
    var doc = $("#doc").val();
    var rg = $("#rg").val();
    var dtnas = $("#dtnas").val();

    if (!nome) {
        showMessage("Dê um nome ao fornecedor.");
        return;
    }


    // decidi fazer a validação da regra de negócio no client-side já que é possível
    // se for pessoa física
    if (doc.length == 11) {
        if (!rg) {
            showMessage("Necessário informar o RG para cadastro Pessoa Física");
            return;
        }

        if (!validaDataNascimento(dtnas)) {
            showMessage("Data de nascimento inválida");
            return;
        }

        if (oEmpre.uf == "PR") {
            if (getIdade(dtnas) < 18) {
                showMessage("Não permitido fornecedor menor de idade para empresas do Paraná");
                return;
            }
        }
    }
    try {
        showLoading();
        var fornec = {
            id: 0,
            nome: "",
            dtcad: "",
            dtnas: "",
            doc: "",
            rg: "",
            empre: 0,
            contatos: []
        };
        fornec.id = cforne;
        fornec.nome = nome;
        fornec.doc = doc;
        fornec.rg = rg.substring(0, 10);
        fornec.dtnas = dtnas;
        fornec.empre = empre;

        
        $("#contatos li").each(function () {
            var nomec = $(this).find(".nomecon").val();
            var fonec = $(this).find(".fonecon").val();

            if (fonec) {
                var fone = {
                    nomec: "",
                    fonec: ""
                };
                fone.nomec = nomec;
                fone.fonec = fonec;

                fornec.contatos.push(fone);
            }
        });

        PageMethods.salvaFornecedor(fornec, salvaFornecedor_cb);
    } catch (e) {
        showMessage(e.message);
    }
    
}

function salvaFornecedor_cb(PbReturn) {
    hideLoading();
    if (!PbReturn) {
        showMessage("Fornecedor não cadastrado. Verifique os dados e tente novamente");
        return;
    }
    showMessage("Cadastro realizado com sucesso!");
    window.setTimeout(function () {
        window.history.back();
    }, 2000);
    
}

function getIdade(dtn) {
    if (!dtn)
        return false;

    var s = dtn.split("/");

    var dia = parseInt(s[0]);
    var mes = parseInt(s[1]);
    var ano = parseInt(s[2]);

    var d = new Date();

    var idade = d.getFullYear - ano;

    if (mes > (d.getMonth() + 1))
        idade = idade - 1;
    else if (mes == (d.getMonth + 1)) {
        if (dia >= d.getDate())
            idade = idade - 1;
    }
    return idade;
}


function validaDataNascimento(dtn) {
    if (!dtn)
        return false;

    var s = dtn.split("/");

    var dia = parseInt(s[0]);
    var mes = parseInt(s[1]);
    var ano = parseInt(s[2]);

    var maxd = 31;
    if (mes == 2) {
        maxd = 28;
        if (ano % 4 == 0)
            maxd = 29;
    }
    if (mes == 4 || mes == 6 || mes == 9 || mes == 11)
        maxd == 30;

    if (dia > maxd || dia < 1)
        return false;

    if (mes > 12 || mes < 1)
        return false;

    return true;

}

function setEmpre(PoReturn) {
    hideLoading();
    if (PoReturn != null) {
        oEmpre = PoReturn;
    } else {
        showMessage("Não foi possível obter os dados da empresa");
    }
}

function validaDoc() {
    try {
        var doc = $("#doc").val();

        doc = doc.split('.').join('').split('-').join('').split('/').join('');

        if (doc.length != 14 && doc.length != 11) {
            $("#err_doc").show();
            $("#err_doc").text("CNPJ deve ter 14 dígitos e CPF deve ter 11 dígitos");
            return;
        }

        if (doc.length == 11) {
            $(".pfview").show();
            $('label[for="doc"]').text("CPF");
            var cpf = doc.substring(0, 3) + "." + doc.substring(3, 6) + "." + doc.substring(6, 9) + "-" + doc.substring(9);
            $("#doc").val(cpf);
        } else if (doc.length == 14) {
            $('label[for="doc"]').text("CNPJ");
            $(".pfview").hide();
            var cnpj = doc.substring(0, 2) + "." + doc.substring(2, 5) + "." + doc.substring(5, 8) + "/" + doc.substring(8, 12) + "-" + doc.substring(12);
            $("#doc").val(cnpj);
        } else {
            $(".pfview").hide();
        }
            
        showLoading();
        PageMethods.validaDoc(doc, validaDoc_cb);
    } catch (e) {
        showMessage(e.message);
    }
}

function validaDoc_cb(PsReturn) {
    hideLoading();
    if (PsReturn) {
        $("#err_doc").show();
        $("#err_doc").text(PsReturn);
    } 
}

function desabilita() {
    $("input").attr("disabled", true);
    $("button").attr("disabled", true);
    $("#cancel").attr("disabled", false);
    $("#cancel").text("Voltar");
}

function limpa() {
    $("input").val("");
    $("#err_doc").hide();
    $("#err_doc").text("");
}

function showLoading() {
    $(".progress").css("visibility", "visible");
}

function hideLoading() {
    $(".progress").css("visibility", "hidden");
}

function showMessage(PsMsg) {
    $("#modal .modal-content p").text(PsMsg);
    $('#modal').modal();
}

// esta função peguei pronta na internet
function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}