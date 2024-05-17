SELECT * FROM hc.medicare_epi;

-- How many physicians do you see? 
select count(Rndrng_NPI) as number_of_physicians
from hc.medicare_epi;

-- How many ESI patients are they treating
select count(Rndrng_NPI) as number_of_patients
from hc.medicare_epi

select Rndrng_NPI, count(Rndrng_NPI) as no_of_patients
from hc.medicare_epi
group by Rndrng_NPI
order by no_of_patients desc

-- geographical distribution of physicians
select Rndrng_Prvdr_State_Abrvtn as state_name, count(distinct Rndrng_NPI) as number_of_physicians 
from hc.medicare_epi
group by Rndrng_Prvdr_State_Abrvtn

-- key physician specialities
select Rndrng_Prvdr_Type as speciality, count(distinct Rndrng_NPI) as no_of_physicians 
from hc.medicare_epi
group by Rndrng_Prvdr_Type
order by no_of_physicians desc


-- Segmentation of physicians on the basis of speciality and patient_volume

SELECT
    Rndrng_Prvdr_Type as speciality,
    Rndrng_NPI as physician_id,
    Rndrng_Prvdr_Ent_Cd as type_of_entity,
    COUNT(Rndrng_NPI) AS ESI_patient_volume,
    CASE
        WHEN COUNT(Rndrng_NPI) between 0 and 4 THEN 'Low'
        WHEN COUNT(Rndrng_NPI) between 5 and 8 THEN 'Medium'
        WHEN COUNT(Rndrng_NPI) >=9 THEN 'High' 
        ELSE 'Unknown'
    END AS ESI_Patient_Volume_Category, 
    CASE
        WHEN Rndrng_Prvdr_Type IN (
            'Anesthesiology', 'Physical Medicine and Rehabilitation',
            'Pain Management', 'Interventional Pain Management',
            'Certified Registered Nurse Anesthetist (CRNA)',
            'Interventional Radiology', 'Orthopedic Surgery', 'Neurosurgery'
        ) THEN 'Pain Management Group'
        
        WHEN Rndrng_Prvdr_Type IN ('Diagnostic Radiology', 'Nuclear Medicine') THEN 'Diagnostic and Imaging Group'
        
        WHEN Rndrng_Prvdr_Type IN (
            'Family Practice', 'Internal Medicine', 'General Practice',
            'Sports Medicine', 'Emergency Medicine', 'Nurse Practitioner',
            'Physician Assistant', 'General Surgery', 'Critical Care (Intensivists)',
            'Hospitalist'
        ) THEN 'General Medicine Group'
        
        WHEN Rndrng_Prvdr_Type IN (
            'Neurology', 'Rheumatology', 'Psychiatry', 'Nephrology',
            'Neuropsychiatry', 'Preventive Medicine'
        ) THEN 'Specialized Medical Fields'
        
        WHEN Rndrng_Prvdr_Type IN (
            'Ambulatory Surgical Center', 'Osteopathic Manipulative Medicine',
            'Undefined Physician type', 'Clinical Laboratory',
            'Clinic or Group Practice', 'Independent Diagnostic Testing Facility (IDTF)',
            'Hospice and Palliative Care'
        ) THEN 'Others'
        
        ELSE 'Uncategorized'
    END AS Provider_Category

FROM hc.medicare_epi
GROUP BY Rndrng_Prvdr_Type, Rndrng_NPI, Rndrng_Prvdr_Ent_Cd
order by speciality, ESI_patient_volume desc 

select Rndrng_Prvdr_Ent_Cd, count(Rndrng_NPI)
from hc.medicare_epi
group by Rndrng_Prvdr_Ent_Cd




