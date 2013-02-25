## redmine_issues_macros

  Плагин предоставляет 3 макроса: {{related_issues}} и {{child_issues}} для задач, {{issue(ID)}} для wiki страниц.


 {{related_issues}} выводит все связанные задачи с текущей. Если у связанной задачи есть подзадачи, то выведет их под ней с заголовками на размер меньше.

 {{child_issues}} выводит все подзадачи текущей задачи.

 {{issue(ID)}} выводит задачу, если пользователю можно её видеть, в противном случае ничего. ID обязательный параметр. Если в выводимой задаче используется один из предыдущих макросов, то выполнит их (!Разрешение на просмотр подзадач не проверяется).


Доступные параметры для {{related_issues}} и {{child_issues}}:
{{[related|child]_issues(level_param=(all|1,2,3...), subject_param=(3|none,1,2,3...), task_param=(none|full,link)}}

Для {{issue(ID)}}:
{{issue(ID, subject_param=(3|none,1,2,3...), task_param=(none|full,link))}} первый параметр обязателен/

* level_param - количество выводимых уровней, по умолчанию all - т.е. все, иначе можно проставить сколько уровней выводить.
* subject_param - размер <h> тега, по умолчанию с h3, но можно указать none тогда без заголовка вообще, или номер. В каждой подзадаче уровнем ниже размер заголовка уменьшается на 1.
* task_param - none - по умолчанию не выводим номера задачи, также можно указать full тогда задача выводиться в стиле "Tracker Number: Subject", или link тогда задача выводиться как "Subject #Number".

## Установка

```bash
  git clone https://github.com/twinslash/redmine_issues_macros
  run bundle install
```

## Примеры использования

{{child_issues}}, {{child_issues(,,link)}}, {{child_issues(1,,link)}}

{{related_issues}}, {{related_issues(all,none)}}, {{related_issues(,2,link)}}

{{issue(14)}}, {{issue(14,2,link)}}
