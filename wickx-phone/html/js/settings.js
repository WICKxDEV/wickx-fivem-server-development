WKX.Phone.Settings = {};
WKX.Phone.Settings.Background = "default-wickxcore";
WKX.Phone.Settings.OpenedTab = null;
WKX.Phone.Settings.Backgrounds = {
    'default-wickxcore': {
        label: "Standard WKXCore"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        WKX.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        WKX.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        WKX.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        WKX.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        WKX.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", WKX.Phone.Data.AnonymousCall);

        if (!WKX.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});


$(document).on(
    "click",
    "#phoneNumberSelect, #serialNumberSelect",
    function (e) {
        // Get the title of the clicked element
        var title = "";
        if ($(this).attr("id") == "phoneNumberSelect") {
            title = "Phone Number";
        } else {
            title = "Serial Number";
        }

        // get the result id of myPhoneNumber or mySerialNumber
        var textToCopy =
            $(this).attr("id") == "phoneNumberSelect"
                ? $("#myPhoneNumber").text()
                : $("#mySerialNumber").text();

        // Copying the text to clipboard using Clipboard.js
        var clipboard = new ClipboardJS(this, {
            text: function () {
                WKX.Phone.Notifications.Add(
                    "fas fa-phone",
                    "Copied " + title + "!",
                    textToCopy
                );
                return textToCopy;
            },
        });
    }
);

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = WKX.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        WKX.Phone.Notifications.Add("fas fa-paint-brush", "Settings", WKX.Phone.Settings.Backgrounds[WKX.Phone.Settings.Background].label+" is set!")
        WKX.Phone.Animations.TopSlideUp(".settings-"+WKX.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+WKX.Phone.Settings.Background+".png')"})
    } else {
        WKX.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal background set!")
        WKX.Phone.Animations.TopSlideUp(".settings-"+WKX.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+WKX.Phone.Settings.Background+"')"});
    }

    $.post('https://wickx-phone/SetBackground', JSON.stringify({
        background: WKX.Phone.Settings.Background,
    }))
});

WKX.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        WKX.Phone.Settings.Background = MetaData.background;
    } else {
        WKX.Phone.Settings.Background = "default-wickxcore";
    }

    var hasCustomBackground = WKX.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+WKX.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+WKX.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    WKX.Phone.Animations.TopSlideUp(".settings-"+WKX.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

WKX.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(WKX.Phone.Settings.Backgrounds, function(i, background){
        if (WKX.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            WKX.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            WKX.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    WKX.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    WKX.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    WKX.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = WKX.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        WKX.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Standard avatar set!")
        WKX.Phone.Animations.TopSlideUp(".settings-"+WKX.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        WKX.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal avatar set!")
        WKX.Phone.Animations.TopSlideUp(".settings-"+WKX.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('https://wickx-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    WKX.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    WKX.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            WKX.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            WKX.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    WKX.Phone.Animations.TopSlideUp(".settings-"+WKX.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    WKX.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});