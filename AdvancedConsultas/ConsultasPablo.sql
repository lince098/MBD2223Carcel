-- Celdas ordenadas por el número de delitos de los reclusos que la ocupan de
-- mayor a menor. AKA celdas mas chungas a menos chungas


select c.id_celda, count(d.nif) "delitosCount" from celda c 
inner join recluso r on c.id_celda = r.id_celda
inner join delitos d on r.nif = d.nif
group by c.id_celda
order by 2 desc;

-- Las celdas o celda con más delitos acumulados por sus reclusos
select c.*, agg.DELITOS  from celda c 
inner join 
(
    select c1.id_celda ID_CELDA, count(d1.nif) DELITOS from celda c1
    inner join recluso r1 on c1.id_celda = r1.id_celda
    inner join delitos d1 on r1.nif = d1.nif
    group by c1.id_celda
    having count(d1.nif)= 
        (
            select max("delitosCount") from(
            select c2.id_celda, count(d2.nif) "delitosCount" from celda c2 
            inner join recluso r2 on c2.id_celda = r2.id_celda
            inner join delitos d2 on r2.nif = d2.nif
            group by c2.id_celda)
        )
) agg on c.id_celda = agg.ID_CELDA

;

-- Lista de reclusos voluntarios y subcontratados distinguibles

select p.nombre, p.apellidos, 'Recluso' "Empleado/Recluso" 
from subcontrata_voluntario sv 
inner join recluso r on sv.nif = r.nif 
inner join  persona p on p.nif = r.nif

union

select p.nombre, p.apellidos, 'Empleado' "Empleado/Recluso" 
from subcontrata_voluntario sv 
inner join empleado e on sv.nif = e.nif
inner join persona p on p.nif = e.nif
;

-- Sueldos diciembre
select NIF, sum(SUELDO)"Sueldo Diciembre" from (
select e.nif , count(*) * e.euros_horas_noche * 8 "SUELDO"
from empleado e
inner join turno t on e.nif = t.nif
where cast(to_char(t.entrada,'HH24') as integer) >=0
    and cast(to_char(t.salida,'HH24') as integer) <=8
    and t.entrada >= to_date('01-12-2022','DD-MM-YYYY')
    and t.salida <=to_date('01-01-2023','DD-MM-YYYY')
group by e.nif,e.euros_horas_noche

union

select e.nif , count(*) * e.euros_hora * 8 
from empleado e
inner join turno t on e.nif = t.nif
where cast(to_char(t.entrada,'HH24') as integer) >= 8
    and cast(to_char(t.salida,'HH24') as integer) <= 23
    and t.entrada >= to_date('01-12-2022','DD-MM-YYYY')
    and t.salida <=to_date('01-01-2023','DD-MM-YYYY')
group by e.nif, e.euros_hora
)
group by nif;



-----------

-- parejas de delincuentes sin delitos comunes

select p1.nombre "NOMBRE 1", p1.apellidos "APELLIDOS 1", p2.nombre "NOMBRE 2", p2.apellidos "APELLIDOS 2" from recluso r1 
inner join persona p1 on r1.nif = p1.nif
join recluso r2 on r1.nif < r2.nif
inner join persona p2 on r2.nif = p2.nif
where 
    not exists(
        select d1.tipo_delito from delitos d1 
        where d1.nif = p1.nif
        
        intersect 
        
        select d2.tipo_delito from delitos d2
        where d2.nif = p2.nif
)
order by p1.nombre, p1.apellidos, p2.nombre,p2.apellidos






