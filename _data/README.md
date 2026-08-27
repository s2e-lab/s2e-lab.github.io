# Overview

It has miscellaneous lab metadata.

## `members.yml`

`members.yml` stores the people displayed on the Members page. Add each person under the section that describes their role:

- `professors`
- `postdocs`
- `graduates`
- `undergraduates`
- `alumni_graduates`
- `alumni_undergraduates`
- `visiting`

Each member supports the following fields:

| Field | Required | Description |
| --- | --- | --- |
| `name` | Yes | Member's full name. |
| `position` | Yes | Role, such as `Ph.D. Student` or `Undergraduate Student`. |
| `text` | Yes | Department or academic program. |
| `org` | Yes | Institution abbreviation, usually `ND`; other examples include `BUET` and `SUSTech`. |
| `img` | Yes | Profile image filename in `assets/img/members/`. |
| `time` | Yes | Membership period, such as `Fall 2026 - Present`. |
| `orcid` | No | ORCID identifier only, without the `https://orcid.org/` prefix. |
| `new_position` | No | Current role for an alumnus or alumna. |
| `social` | No | List of contact or profile links. |

Supported `social.title` values include `globe`, `linkedin`, `twitter`,
`github`, and `envelope`. Use a complete URL for `social.url`; for email, use
a `mailto:` URL.

Example:

```yaml
graduates:
  - name: Example Student
    position: Ph.D. Student
    text: Computer Science and Engineering
    org: ND
    img: example.jpg
    orcid: 0000-0002-1825-0097
    social:
      - title: globe
        url: https://example.com/
      - title: linkedin
        url: https://www.linkedin.com/in/example/
    time: Fall 2026 - Present
```

Mascots use a smaller format under `mascots`:

```yaml
mascots:
  - name: Example Mascot
    img: example-mascot.jpg
```
