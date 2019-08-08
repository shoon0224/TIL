import React from 'react';

const styles = {
    wrapper: {
        width: '100%',
        borderBottom: '1px solid #3f3f3f'
    },
    container: {
        display: 'flex',
        width: 1000,
        margin: '0 auto',
        padding: 15,
        alignContents: 'center',

    },
    profileImage: {
        width: 300,
        height: 300,
        borderRadius: 150,
        border: '1px solid #3f3f3f'
    },
    profileContainer: {
        padding: 15,
    },
    staticDataContainer: {
        display: 'flex'//옆으로 나열

    },
    staticData: {
        marginRight: 15, //게시물  v 팔로잉 v  팔로워 하기 위해서 마진을 준다.
    },
    button: {
        width:100,
        height:35,
        backgroundColor:'#0d78d6',
        borderRadius: 25,
        border:'1px solider #d1d1d1'

    }
}

const Header = () => {
    return (
        <div style={styles.wrapper}>
            <div style={styles.container}>
                <div>
                    <img style={styles.profileImage} src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExMVFhUXGBcYFxgYGRgYGhgaFxcWFx0aFxsYHSggGB4lGxcVITEhJSkrLi4uFx8zODMtNygtLisBCgoKDg0OGhAQGi0dHR8tKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLSstLSstLS0rLf/AABEIAO4A1AMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAgMEBQYHAQj/xABLEAABAwEDBgkHBwoHAQEAAAABAAIRAwQhMQUGEkFRYQcTInGBkaHB0TJSVJOx0vAUF0JikqLhIyRDRFNygrLC8RUWJTNzg+JjNP/EABgBAQEBAQEAAAAAAAAAAAAAAAABAgME/8QAIBEBAQEAAgIDAQEBAAAAAAAAAAERAjESIQMyUUEiYf/aAAwDAQACEQMRAD8A3FBVc8ImS/TaX3vBdPCFkz0yl97wTV8b+LOgqv8AOHkz0yl97wXHcIuSxjbaX3ubYmmVaUFVjwi5L9Npfe8EPnFyX6bS+94IZVpQVWPCLkv02l97wQPCJkv02l97wQyrSgqv84eTMfllL73ggeELJnplLb9LwU08b+LQgqueEPJg/XKX3vDeEoc/MnBumbXT0dvK19G4qmVZEFVvnFyX6bS+94IfONkv02j1nwQyrSgqqOEbJfptL73gjDhEyX6bS7fBNMq0IKr/ADiZL9NpdZ8EPnDyX6bS7fBDxq0IKrjhEyX6bS7fBcPCLkv02l97wTTxq0oKst4QMmEwLZTmJ+lh1IvziZLmPltKZiOVj1IZVoQUTY85bLVBNOs1wFxInGJ2JhWz/wAmsMOtlIHfpauhTYeN/FlQVYp8IWTHGBbKRO7S8FI2DOayVnFtKu15beQJu1X3JsPG/iWQTV+UaQxeO3wQTYeN/Hkomb7j8X9xXHNvPPPt/shTZF0dh60W1tOEHGbh8fELG+3qs9OP+OpOgxhF450yBJiQ7q3I1Sudh6lbNSXOzpwpbBq9l3Ymddom7CLkeuwjVjG03AeKSDSnGJyrujI3hHiQI2H2rrWYLrxHSCB0n+yqSOHZs9q69pjmvHNr8V1lOfjrKdcUNqKaVBAHx5qNVc65smBquu13dfajFkb4w7Ind4JzZbGXXgEn4vKmmGjARs6gewrryTGH2WjVuClH2GPKLW4YuAN92BhI2qw6N1+MSAYw1EwJ5ipsWRHaM7OoD2JSnTIT2yURhE9MezSUzTpDUG7uSGzcMDUJB+ymmIDinY6MDDyQJnDVebj1IpoedA3a+pTlWxuLYDTOJAc03/u04HWFH1LLIun4GxRUc57RgOkx8daQDpkgSG/2v3ItZsdqd2agRZ3OOBIA23EXnrW8k9sbb6L5Fs4eXve6NEEgec7UCmVT/dP7/wDUrBmcwFlpnVRqEc8sVfcPyn8fepvutZkjXuD6TQqR57T9wXLMM4Byxzu9q1Xg4p/m9S79J/QFmGczOWOd3tC58fs3frTLI7ZceZanwaDRtFoB80DEankLL8jNlzhuHtWp8HYmvWJH6Omegk9uCc+zj9V5tdt0XQBq84j2BBL1nwcJuxn8EFlHna0ubJmmzH6/vprVvuDWt5tL+pxUtbKLZPScE0Ibrx5luBk1m0nqHgiubz9ngnrQ04lcDRd8bVRHmmdvZ+CM6zHzlJaDZxXalNo1iLpi9NTEU6zHzihxBu5R+NikKujtRDFyqYSZSZ57vsN8UU0LyZkb2geKWeQEDWbEdyuISDQO4Xe7zK18HNgbaLUyjVl9NxMiT5r3RBOji0alV2VRP4K88FhAtbHagTpGCYBZUEmNUkDpTIXcanYs0LHTbDaEgi8EAg3T5Pk9ip/DHk6mylQcymGuNRzSWta2RozB0cb71pNK0sI8puGw7FSOFaH0aMEQKjpIBu5N0pfUc+Ft5Rk9koRq17PatrzLyDQ+TUqvFAVHtl7m3F0PMTB2LJ20hNxC2fNO0NFjoAkAht4IPnFTjddPl9Q8r5HouaWvphwOpwDsAcNKY6FgFvpQ8yTO++cBJOv8V6IdaGR5TZ6dhWBZxMio+RF5xF8/EJyZ+HuqXavK6+9SbWfmZP1+8KNrYi/b3qYYz8xn6/8AUE5fx0490+zJp/k7T/wVPbTVaA/K/wAferbmRTJpWmP2VSeumq0GTWH7/wDUpL7q2eo2Dg1afk9SNbzf/CFmedzIqC7W7uWs8HtMCg/9+eyO5ZZns38qMfpe0LHH7NXqovII5buYYc61Dg1njq8j9GzH94x0Qs0zdHKdzDvWpcHtGH1nCILGAdBcrz7SfVb7Vai10AH46UE1ygHF3kg3DHR70Fy9tyTGW2qxXm4a1FWikNbepWTKdCHujHle1RVWz67lqVbES6ygiIxMJOjYhAGoc6kuJJicZGG2V2nR1fBWtTxMhZRO6diW+QMvG5O2U5BEa8UVzMeZNLIZmwAG7tRa1haB0p25wCK9swcVdTxiONkEg953IrqYJwT17IdHxegxon4uvV1mwlZrODeALu3crhmLklla0MbUbySTIBINzHnHEXgKCoUBI37lduDymRXZ+8cP+Oqkvs5zONXanmnZhEB4/jOxV3PXINKmxhYHX6QMu0vNjHnK0Bo+LtirGfn+3TH1nd3et8unn+O/6jMbFk1l0ycTibr93OVpeQM2qLqFNx4yXCTDrsTqhUayM8nbt6VquQR+Qp7dG+7XJWeHbp8vqRG2jNSgQb6uGp42HcsjyjSAYC6dItBJk3nRBOuMVvdQXHm2bisPyz5NzdTcdXJBuTmfB7tZ3aS4EQTiTibrypym3/T5+uf5goW1jlDnPtKslNv+mf8AZ/U1OXUb491I5hUfze0nbTqD+RVSkPzgCLuMPtKuuYLPza0QfoVP6VVLMwfKTPnu69IrM7q3qNhzF/2XYDlH2LK8976rP4vatVzOpxRfcPLP8rVl2eo5VPmd7Vnj3Fv9RebjTpvjdh0rT8wdIVKuzRb7Ss3zaZLn3ebs2laTmE2KlYE3aLPacertV59pPqmsqudp/wC8G3YaLTrO0IIuVaTC+8ah529dWHSZijZ0WrijUqOktBNwxvIAxga9qibBlJlYEtDhBi+NQB1Hem+eNvLaoIfpAmXMmWgCANIDXeT0ImS7U2CWwA4agt+P+dTy/wBYekG7oTW3vcGtIuwkkG6YAiEtRtMODhBgg9IMouWLbxgcTAJLTAwEaLbtepOM9pyvqjW2wVqDab3aOjVbpsOk69twvE8nEXJLLOS61B/F1gwOgOMOefKN14Kmc5co0qlnsrGaWlSptY+WwJuPJOvycUXPfKNK0V+Mok6OjTF7dEyDfcvROH/HkvO/qEylkuvQFN1QNAqMD2ctxlpEyYN3MUetky1NoMrlreLeXBjtI3lszcDIwOKl87MpUq1OzimSTSoNY+WwNLktI3670e25VpOydZ6DSeMpuqF40SIB0o5WBxCeP/F87+qvZ2v237OxPqbDcCAL92zcisfA5Nx8V1lV07CMPFcK9MP7OyCOfp57lccy2D5RSFxBfs/+VYqkWcOmdN033E3dUK15o2wU7RRdVeA3TN5EBv5KqLyN5HWnHtOf1rWmUWj6I6tyrOerQAyAL9L2tUv/AI5ZyLqzOs7FWs8cqUqhptp1GuufOiZi9mOxdOXTzfH9oq1lMhgx0bpx0ZM39a0/N9gNnpmNu3znLMKNANvBjAY44Cd5V+zbyzQFnph1amHAGQXgEcp2I1LPDt1+bpN2qm3Qdd9E7fNKxrLEaH8I69Ada1i2ZYs/Fv8Ay9PyT+kHmlZPlWoNEAbAPuhPkPg7rOK9WXxGBPerYG/6X/GP5lWK1nDXTOJd3hW6lT/0oE+cP505/wAb4pbMFgFlrc1T2tlU+zN/Oh/yH+Yq5ZhNmy1J+v08poVQspItLf8AkPY4rE7rTW81Ro0HT57sP3WrL88xy6d/0T7VqGbr5oOgjynfytWYZ5Dl09R0b+tTj2X+kM1gJqdHerzm5bWUXVnOMAtZr1S468dao+aZ5TjKttLJ4qkDGBdPQnLsk2IzLPCARVIZRBA2uM4nG7FcUhaM0mzhHOEFqcuP4nhy/UXl/g6tLnuLSIJJva/WZxA501bmXaWDDAag7vhahlC0VpMVSBucfFRVoytXF3H1Oh0rrXn41Qv8FtQuNMc8kT0Qm7s3LS44Mx2nwV1tGW65uNV553JvSypU0hJMLM7b8riGbmzawAHBmqL9/MiW/N+1NIGi3VrG1aRla2ANoHaB3JrnLXHHNGuBqldZycbGbWzN61gcqmBOHKC67Ny1aGk5gAP1h3LTM6o0aUDFuKWyrTaLFTMX/wB080xj77FV0j+Tx36+pO7Pkm0aqXaFZWaMyB0pwyuN/SVzx2nKoChm/aDfxbR/EFPZJyLaJIIbF2DwcJ6k8pVNsdqsObpBeOn2JJE5c7UYzJNcfR+8EytuQ6wMtZjqLhHOFowpjYo7LogN6VdlY2xn5yLaT+jb9tqnqGSq8eR2t8U7sz71aLM0aA5k9ReXK1UjkqtBGhccb2qpZVzftZL9GkDJP0m3jm6lrxaIVbtbmyZlLlOPK8WM2vNO3A3Wd5F+EHbv3qbqWWrSyYWVWOYQ5tzhGLtSuVqbZz5bqg5nOHeozKVLJ7qehUq19GQcSbx0KWa3OdRuZ1tFOx3kDTdUbeQPpyqtYHj5U361R0cxLkpnPZqTWRZatR1ENMte4zpF41REaM37So7IBPyiiDiHX9AKeH9anNrWSbSylZalR5hrS6fst61m+d7uWydTe8q+WOzk0tCSTpvM7ATjsBIVAzsfL264pj2lc5Pbpu6Lmy69wjWOhaJmvDqhnUOq9Z5myQCb75w2xC0jNurD5i4gDkyYJOvt6lnn21x6T1ps0m+67YEEztuUXaZAZcLhJF8a0FjFQ2VnkEqBr2o/Fym8seUbutQdajOIleuvFDQ2s6o7EKdZ0i7rSosbdfZKVFlGIEdcqNasOW7SSygLrmibwdmGxNcqWuakgaheUS1UvyYc4wxgkuNwACaZOa+08ttN4p6nvhod+6CZI3xCkiWpjLVrDxS1w2+RgneVLXNkptvu3QNaZVrLMaRF2+B90H2o7rQNEMJBaNQpg9ririagS8nZzJak3mUnxoGAf1sb7GrPMtZRdVqOc55LNO4aZkNwGA2e1WTTV9s4ExIntVoza8scxWSZAyw4VmipLgy4aI0nFpa7U290dy0DIudlkaQS8gRcdBxx5gl4mtGIgKs572t9GhxjKemQb8bgTeTGoJP/ADzY/wBt9yp7qhs5c6bHWouYLTBc0iSx907tELMnsRuS87GkhtRsTrbhjdcdy0TJdsZUYHMe1w3d6wWhlhgfoVQ1wFwc26d7THNcR1q5ZEy3TZHKJZFzmjlNG9ovjeJHMt8uKa1N7hB+NSgLTUC7Ryy0MD3FtSmRc9p9sfgoy25RoxPGMAOBLg0dvQsSLulX1qWsLvyuhF9Kegd5UbVs5xF4N4IvHQcEhUssjEqhbOqwUrTZH06LGMqOLYc7RaBDgTe2TqjpXaVgyaGjjqdEVCSTomYkmL4E3blF18mSDLnDrSIzXa/B5B6O8q/wT5yxY6IilUIGGjBeDqum8bMehZlnnSDKzQJ8i+dukVaquY7o5NS/+HxULlPM61PdJOnAgE3mOeVnuunG4is3rwRE8oXdF92u5WzIOVeLeACQDfN8A3YzdhvUDY8iWuzkkUC4HZJ2auhFygLQ4jQoVQIMy0iCSMNuCnLjrfHn6WLKuWDxhhzhIBv29aCptS0WkGOLcOe49KCeC+caHlStyjJJUVUrndCdZTtUm4qPs8OdDsACTzDV04LpjzJHJVA1JcSGMGs4nmCdAspudotBvGg4nVoicRcdLSwGEKt5RyjXY+WMdAuAY3SbHRf04pOx5ce5wa+zVpOvRdHaLukqY342xY61dzpBIg4hJuqE/SnViYSlFg2RuP4JV+i0S4gDejBs0oMotL9O/SF3lOjZ5Mx2JB2clkaYNanPOPFSNjyjTqCab2OG4goGuUqVR9NzGQC4QSSRccYuxVWfmfU3H+Id4V943ck32oAdka0lGc1c1LSDyG33fSaJgyJ2FIVc2baSTxYJOPKatEdlSm3ynNbJ+kQJ3CdaVFuA8qG7NIsBPMJknmV2ozB2bFt/Y9Tm+Kb18gWtgl9FwG2W9l961tuUWqOt7m1HSXbgNiaKFm9kxheflQLaYEmbpg4TiNpjYp/KNksRZNjqg1BH5HSc8OH1Sb2u14noUsyyUb5PWYHYJR7FYLO2pxobT0/O5RPaIV0QGTjbaR0qLXwfKaYE88kA8+KlbXk60WkaLm06LT5Q8rSO264e1WenWpnW3t8EHV2geUNimhDNPJrbFTcwVQdI6REENF0clsXbziVK1a1N2OiVFV6t03AbT3KCtWddmYY0y8jEMDnxz6IICirZUslJwgVI6R+BR6Fiqtwe1438lw7iqlZc8bK4w5zmfvtc0dZEKzU2sqMueQDBDmOggi8EEb0Dt9scy57SOcd+tMbVlamMXBSFG3lgi1OYWOIa1wYYnCH447SMdYUZlzNqlUY6rQLg4AnRbLw6NTW+UDuHUgaf5hot+l1Ce5N6ud9mA5QceZre9VbKOTK1J2i5haYBEgiQcDeoivZicZlayNRarRndY3GeKd9liCpJouF3cgmRcXq3vEm8plZ38vXr27Epa6ok3Qo+vWcOU28j6JwcCCCCRhIJv1IwkLTlR9PAB2GOKc2fK2m0FVujVY6CKz4Jva9ocRulpBu3hOTTa29lRrgdV7SPtKlietOUmU6bqjjAaJKoGVMsvry+q4hn0aYwjVpAeUTvuCdZ12o8Uyn5zhPML/bCr9YmRzfFyEhRtsOpt2q/wStktRDpY5zHanDHwPMUnZwIcCQNETeccLhdeedFoUZDnGQGReBvm86rr1LcantpmaecnHMLKoHGNHQ4HBw7eopbKFqvJmVnmRLSWWikRrlp5iNL2hXGu8kpjN9ELRVm43hEY4AzeSMJJPtRqllcZuN2KRFB2xVDwWwofKymfFO2IcW7Ygei0ozbVCZfJ3+aVw0XbCgkRbt6UpWwkm9RWgRqRLTaNCm46wCUEfnHl59dxphxFJlxAPlHWOZQT7SRyQI2f2SdPyRfz9JTrKpHGnkkMhmjpCCBojZqxWd943J603pW1w334bejAqayRlo0HNh720SeU1pJDSRi2LwJ1DBQ9cCSGQReNKCJvnXeEiz/AG3fHxgFpO205PyjLQdKWkDG+QRrnFS1ktzaUlvJJOkYmCYInZrN2GvFZ7mjaybMydUjqJ7kvnPbiyzuAN74aP4sewFTGdXm35ao24cSdB1Rt4cDym8+4gHsUa7NxpuJTTMDJoZS0ngNJDTBuN+EdnWrvTiL1mtapTszhP4IK88VzIKLrI7ZUF5uvUbVtcYQE8e8EXQo+sAbj2Qtsoa3VGlxccTrEhNBanjB56b1JVrGDqPWm7snbyqiPttpfUjSI5OC61um36w/FOKmSz53Ykm2BzTIdHR+KLKI0i7SYbpwv+AnVMks0SIaJBMmXCbvjelG0qn1D0eCK+yvdi6BuClmrLhvZLQBWY4mAHX7hBVkqZcpA3VyOZjj2gqvtyWNpTgZHb5zuzwVSpU5yN/bVPsn3kR2cI/a1Ps/+kwGRGnAu+OhOBkFn1uv8EQp/mEftKn2R7yH+Yh+0qfZHvLrc36evS6/wXf8Ap7HdZQD/M3/ANKvUPeXDnP9er1D3l3/AAGlv6yh/gFPYesoCOzl+tU+y33kxtmWA9pEG8EYDX0qQdkCnsPWUk/IjNQPWUENYqg8l2BuvT210jpNkFwIF4vJA1X7thi5LVMis2lK2fJ723CoQOhGt/iO4txGi1sC+S6MJkXc2tI2twjQbG+MJU27J5dc6o47sOwJSjkmkMWntRDDJOXDRZoQcSbjGKeVMvuqQNDSvBAcA68YEJ7TyPQH6Oek95UvYbNTp3tptHVKCazQslSsBUtLqhgy1hMMBF86LYk86vbI2qo5PyiABAU/QtwOonmiekLNRJ6DdsoJoLYfrdnigoMfqPIF8JpibgITgwcXexJOaPOK2FGtuuEpvWF/kgd6d0yNvalBTa4m8g70EY98YtHXcgGiZgJzXZcbu1N30xsQKBwP0fYiOojEO6Ek5hGCd2dhAMgSdXgopOlTE86kGWVus9SLRaZFylG0pE3XbVUM6lFhA27UrZ7MdoI3pxTaN0JTSAxBHMFBw2QRfASVaysH05+N6Wc8G4T7F2z2x9M8glpiLjd2hWFM22dhvE9ncl6dl50RzSSScSZMa75TmmNoRCNSyA4k9QTatYWwYc746FJkzs6ZSVpYRMEKKrtRgnHvS9KzwL4J5k5ogTJN+1OaujiHFFds9naRq9iUdZ2m/oTZlYb05Y9kQQZ6AgkaWTmkA9yUq2Jjd+7xR7K7U0nmXbRTIBB58UQ6oU2hodA6k6oVI/vCr7rXAjSnrKc0LUL/AI71ME+KzUFDstE4QPjnQTBn5gmJ6kk5nOelceUTjSVoO6boEd6AqyUwfVRqbzigkhvSYpHo7U2NoOA1/F6Wp1SBE/igMxhGCVpEtugnmhJsqDWL9uvrS1B7QZgHq9qCToUHdJHVu3INaZxTOpXdqu5vi9L0w6MQNxKIcU6p1nvQe90IlSmcRolN/lkGHABQOqRO5H0CQUSlX1i8I9S1QqAylel2tKastgJQNqM4GNyinJDsUnpkbEj8oJw7UV1YRfCGkLQ0zLUhxhGITtlduJuRHWoHuVCIqmbwU/s0uv0UxfbIwCVoWkmZMXIJkVgIklJVa04ElR/GnnCWq1BNxxUCjN+OwoCofBJPtAgJvVtMKofCqgoYWgoIIvi9qTcYwv50kROEo/FEXkIoOZpHADmTllkuxCamolGHegUNEg3QelJEwYKWNY4JOo3cgWo34FORTm/xTKkCNqWFQygXpud0Lsrrag2oVXogzK0f2RmVAcR1hIMeR+C6x99+CKkGWgYdy7Ufcm7XCMBKMx+rFAZlVoOA6l11pOpEcJ3IhZdcgI6o5G5WEok6kZ6AFh1lNqg0cCUswbUW0N6dqBBwM7UZrzq5kNEpUQgMKq4951SijcEoOk85QJms864RngnE+xFewgpSnUGyUAbZp1jrQS0jUY+OdBBDExdrXZMXrl0riAhF663FG0VwujBAYhca+MEQOJ1IjgdaBY11wVk3rAajPYjUmGEDltZHdX6000SutdE7UD19UFK0GjXemDXynFJ5VD8sjfKI4wk7PU2pR7QdZCgM6r8Xrr7WAE3NMbURzWnegVdaBCRdVJ1pHRBKMwKhdjyjcdOIXGPOxcqzKA9J18lHSM33JVu9QdYEcU4XWN1gGNqMD0oE6klGpU0txBStnaRqQGp5OkTMIJ8ypAwQRFqPA030x3qh766OBtvpjvVD31qaCzoyw8DbfTHeqHvrg4GmemO9UPfWqIIMrPA230x3qh76I7gXaf113qh761dBBlDeBdo/XHepHvpZnA+BhbD6ke+tRQTRl/zQD0x3qh76L8zjfSz6oe+tSQV0ZR8y7fTHeqHvpVvA60frjvVD31qSCaMuZwPNH6471Q99KfNG30s+qHvrTUE0Zi7ghaf1t3qh76A4IW4fKz6oe+tOQTRlzuB1s/8A63eqHvoM4HWj9bd6oe+tRQTRmI4Im+ln1Q99dfwRNP6271Q99aagmjMm8EbfSz6oe+u/NI30s+qHvrTEE0Zq3gmb6UT/ANY99d+adsz8qd6se+tJQTRnLOCsD9aPqx76WHBk3XaSf+se8tAQU0UNvBswfpz9j/0gr4gg/9k=" alt="포르쉐" />
                </div>
                <div style={styles.profileContainer}>
                    <h1>My Name</h1>
                    <p>내 소개 Hi my name is lee sang hoon</p>
                    <div style={styles.staticDataContainer}>
                        <h3 style={styles.staticData}>게시물 100</h3>
                        <h3 style={styles.staticData}>팔로잉 1000</h3>
                        <h3 style={styles.staticData}>팔로워 0</h3>
                    </div>
                    <div>
                        <button style={styles.button}>Follow</button>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default Header;