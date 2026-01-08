window.addEventListener('message', function(e){
    const d = e.data;
    if(d.action === 'update'){
        document.getElementById('pid').innerText = d.id;
        document.getElementById('time').innerText = d.time;
        document.getElementById('job').innerText = d.job_label;
        document.getElementById('job-grade').innerText = d.job_grade;
        document.getElementById('police').innerText = d.jobsCount.police;
        document.getElementById('ambulance').innerText = d.jobsCount.ambulance;
        document.getElementById('firefighter').innerText = d.jobsCount.firefighter;
    }
    if(d.action === 'toggle'){
        document.getElementById('scoreboard').style.display = d.show ? 'block' : 'none';
    }
});
