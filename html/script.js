
window.addEventListener('message', (V7) => {
    const data = V7.data;


    if (data.type === 'Direction') {

    } 
    

    else if (data.type === 'Update') {
        updateHealth(data.health);
        updateArmor(data.armor);
        updateHunger(data.hunger);
        
        updateThirst(data.thirst);
        
        if (data.walk !== undefined) {
            $('.line').css({'width': data.walk / 4.5 + '%'});
        }
        

        let color = "rgba(219, 219, 219, 0.644)";
        if (data.mic.talking) {
            color = "#24d8a2";
            document.getElementById("Voice").style.border = "none"
        }
        if (data.mic.alt) {
            color = "#D64763";
        }


        changeVoiceColors(data.mic.voice, color);
    }


    if (data.vehud === "open") {

        showVehicleHUD(data);
 
    } else if (data.vehud === "close") {

        hideVehicleHUD(); setTimeout(function(){},1001); document.body.classList.remove("fuck")
    }

});


function changeVoiceColors(voiceLevel, color) {
    if (voiceLevel === 1.5) {
        $('.Voice1').css("background-color", color);
        $('.Voice2').css("background-color", "#141414");
        $('.Voice3').css("background-color", "#141414");
    } else if (voiceLevel === 3) {
        $('.Voice1').css("background-color", color);
        $('.Voice2').css("background-color", color);
        $('.Voice3').css("background-color", "#141414");
    } else if (voiceLevel === 6) {
        $('.Voice1').css("background-color", color);
        $('.Voice2').css("background-color", color);
        $('.Voice3').css("background-color", color);
    }
}

let stress = document.getElementById("stress")
let Health = document.getElementById("Health")

let thrist = document.getElementById("thrist")

let food = document.getElementById("food")

let Armor = document.getElementById("Armor")

function showVehicleHUD(data) {
    const carHudElement = document.getElementById("carhudpe");
    
    
    if (carHudElement) {
        // carHudElement.style.display = "block";
        document.body.classList.add("fuck")
        
        ToggleMapShape()
        if (data.vehspeed !== undefined) {
            $('#velocidadtext').text(Math.round(data.vehspeed));
            // by V7
            updateSpeedLines(data.vehspeed)
            
            

         }

        if (data.fuel !== undefined) {
            $('.gasotext').html(Math.round(data.fuel) + 'L');
            document.getElementById("rellenogasolina").style.width = data.fuel + "%"; 
        }

        if (data.gear !== undefined) {
            $('#gear').text('Gear: ' + data.gear);  
        }

        if (data.engine !== undefined) {
            const engineElement = document.getElementById("bter");
            engineElement.style.color = data.engine ? "rgb(248, 164, 11)" : "white"; 
        }

        if (data.setbelt !== undefined) {
            document.getElementById("set").style.display = data.setbelt ? "none" : "block";
        
        }
    }else {      }
}


function hideVehicleHUD() {
    const carHudElement = document.getElementById("carhudpe");
    if (carHudElement) {
        carHudElement.style.display = "none";
   
    }
}
function ToggleMapShape() {
    $.post("https://Dv-hud/ToggleMapShape");
}

function updateHealth(health) {
    const healthBar = document.querySelector('.Health .health-bar');
    const newHeight = health + '%';
    
    Health.innerHTML = Math.round(health);
   
    healthBar.style.height = newHeight;
}



function updateArmor(armor) {
    const armorBar = document.querySelector('.Armor .armor-bar');
    const newHeight = armor + '%';
    Armor.innerHTML = Math.round(armor);
    armorBar.style.height = newHeight;
}


function updateHunger(hunger) {

    const foodBar = document.querySelector('.Food .food-bar');
    const newHeight = hunger + '%';
    food.innerHTML = Math.round(hunger);
    
    foodBar.style.height = newHeight;


}
function updateSpeedLines(speed) {

    for (let i = 1; i <= 22; i++) {
        const line = document.querySelector(`.lineas${i}`);
        if (line) {

            if (speed >= (i * 9)) {
               
                line.style.backgroundColor = 'rgba(255, 255, 255, 0.8)';
            } else {
                line.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';
            }
        }
    }
}


function updateThirst(thirst) {
    const thirstBar = document.querySelector('.Thirst .thirst-bar');
    const newHeight = thirst + '%';
    thrist.innerHTML = Math.round(thirst);
    thirstBar.style.height = newHeight;
}


function updateSpeed(speed) {
    const speedElement = document.getElementById('speed');
    speedElement.textContent = speed;
}



        window.addEventListener('message', function(event) {
            if (event.data.vehride === "yes") {
                if (event.data.inVehicle) {
                    moveNUIToRight();
                } else {
                    resetNUIPosition();
                }
            }
       
        });
    

        function moveNUIToRight() {
            document.getElementById('hudpls').style.transform = 'translateY(-250px)';
        
        
        }
    

        function resetNUIPosition() {
            document.getElementById('hudpls').style.transform = 'translateY(0)';
        }
    
    

document.addEventListener("DOMContentLoaded", function () {

    window.addEventListener('message', function (event) {
        if (event.data.action === 'goPage1') {
            GoPage1();
        } else if (event.data.action === 'goPage2') {
            GoPage2();
        } else if (event.data.action === 'goPage3') {
            GoPage3();
        } else if (event.data.action === 'goPage4') {
            GoPage4();
        }
    });
    

    

});
