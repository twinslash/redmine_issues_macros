## Redmine issues macros
### Description
  Plugin provides 3 macro: {{related_issues}}, {{child_issues}} and {{issue(ID)}}.

  {{related_issues}} displays all issues, related with curent. If related issue has subtasks, they will be displayed after                  related issue's description.


 {{child_issues}} displays all subissues. If subissue has it's own subissues, they will be displayed after                  subissue's description.

 {{issue(ID)}} displays issue with the passed id, if current user allows viewing it. WARNING! permission to view sub or related tasks (if you use one of the macros below) are not checking.

### Installation

Just clone the plugin and restart Redmine
```bash
  git clone https://github.com/twinslash/redmine_issues_macros.git
  # and restart Redmine
```

### Usage
**Avaliable parameters** for {{related_issues}} and {{child_issues}}:
{{[related|child]_issues(level_param=(all|1,2,3...), subject_param=(3|none,1,2,3...), task_param=(none|full,link)}}

For {{issue(ID)}}:
{{issue(ID, subject_param=(3|none,1,2,3...), task_param=(none|full,link))}} "ID" parameter is required.

* level_param - amount of nesting levels, default "all" - i.e. all, or set number of levels.
* subject_param - size of <h> tag for issue's subject, default from h3, or you can specify 'none' for no subject or number.In each subtask level below the header size is reduced by 1.
* task_param - 'none' - by default do not displays the ids of tasks, you can also specify "full" for subject displayed in the style of "Tracker #id: Subject",  or "link" for subject displayed as "Subject #id".


### The usage examples
Subtasks case:

![Subtasks case](https://raw.github.com/twinslash/redmine_issues_macros/master/readme_images/case.png)

{{child_issues}}

![Case](https://raw.github.com/twinslash/redmine_issues_macros/master/readme_images/11.png)

 {{child_issues(1,2,link)}}

![Case](https://raw.github.com/twinslash/redmine_issues_macros/master/readme_images/12.png)

 {{child_issues(,2,full)}}

![Case](https://raw.github.com/twinslash/redmine_issues_macros/master/readme_images/case.png)

 {{child_issues(,none,)}}

![Case](https://raw.github.com/twinslash/redmine_issues_macros/master/readme_images/case.png)

Usage for {{related_issues}} is the same.


{{issue(71,1,full)}}

![Case](https://raw.github.com/twinslash/redmine_issues_macros/master/readme_images/21.png)
