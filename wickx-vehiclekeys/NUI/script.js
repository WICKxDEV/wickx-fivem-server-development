
window.onload = function () {
    var eventCallback = {
        setText: function(data) {
            var key = document.querySelector('#'+data.id+' span');
            var html = data.value;
            saferInnerHTML(key, html);
        },
    };
}
$(function()
{
    $('.container').hide();
    window.addEventListener('message', function(event)
    {
        var cdata = event.data;
        if (cdata.casemenue == 'open')
        {
            $('.container').show();
        }   
    }, false);

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('https://wickx-vehiclekeys/closui', JSON.stringify({ message: null }));
            $('.container').hide();
        }
    };

});

function unlock()
{
    $.post('https://wickx-vehiclekeys/unlock', JSON.stringify({ 
       
     }))
    $('.container').hide();
}
function lock()
{
    $.post('https://wickx-vehiclekeys/lock', JSON.stringify({ 
       
     }))
    $('.container').hide();
}
function trunk()
{
    $.post('https://wickx-vehiclekeys/trunk', JSON.stringify({ 
       
     }))
    $('.container').hide();
}
function engine()
{
    $.post('https://wickx-vehiclekeys/engine', JSON.stringify({ 
       
     }))
    $('.container').hide();
}

