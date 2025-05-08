$(document).ready(function () {
    $("#image").on("input", function () {
        var val = $(this).val()

        $(".photo").css({
            '--img': `url('${val}')`
        })
    })
    $("#name").on("input", function () {
        var val = $(this).val()
        $("#name2").val(val);
    })
    $("#dob").on("input", function () {
        var val = $(this).val()
        $("#dob2").val(val);
    })
    $("#pob").on("input", function () {
        var val = $(this).val()
        $("#pob2").val(val);
    })
    $("#marital").on("change", function () {
        var val = $(this).val()
        $("#marital2").val(val);
    })
    $("#physical").on("input", function () {
        var val = $(this).val()
        $(".physical-properties").val(val);

    })

    $(".idcard").draggable();

    $(document).keydown(function (event) {
        if (event.key === "Escape") {
            $(".create-container").slideUp();
            $(".idcard").slideUp();
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        }
    });

    $(".create-btn").on("click", function () {
        $(".create-container").slideUp();
        $(".idcard").slideUp();
        $.post(`https://${GetParentResourceName()}/create`, JSON.stringify(
            {
                image: $("#image").val(),
                name: $("#name").val(),
                dob: $("#dob").val(),
                pob: $("#pob").val(),
                marital: $("#marital").val(),
                physical: $("#physical").val()
            }
        ));
    })

    $(".bscript").on("click", function () {
        window.invokeNative('openUrl', 'https://discord.com/invite/dxVJ2wxfc6')
    })

    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case "register":
                $("#name").val(event.data.name);
                $("#name2").val(event.data.name);
                $("#dob2").val("")
                $("#pob2").val("")
                $("#marital2").val("")
                $(".physical-properties").val("")
                $(".create-container").slideDown()
                $(".idcard").slideDown()
                break;
            case "openIDCard":
                $(".photo").css({
                    '--img': `url('${event.data.data.image}')`
                })
                $("#name2").val(event.data.data.name)
                $("#dob2").val(event.data.data.dob)
                $("#pob2").val(event.data.data.pob)
                $("#marital2").val(event.data.data.marital)
                $(".physical-properties").val(event.data.data.physical)
                $(".idcard").slideDown()
                break;
        }
    });
});